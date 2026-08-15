return {
  "guill/mcp-tools.nvim",
  build = "cd bridge && npm install",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("mcp-tools").setup({
      tools = {
        dap = true, -- Debug Adapter Protocol tools (requires nvim-dap)
      },
      integrations = {
        -- Only used by opencode.nvim (in-editor panel), which is not installed.
        -- External agents (herdr panes) are handled by push_registration /
        -- register_with_claude below instead.
        opencode = false,
      },
    })

    -- The built-in dap_set_breakpoint / dap_run_to tools open the target file in
    -- a window (splitting a new pane when every window is a dap-ui/terminal
    -- pane) and never close it again. Re-register them with window-preserving
    -- wrappers so agent-driven debugging leaves no stray panes behind.
    local function preserve_windows(execute)
      return function(cb, args)
        local wins_before = vim.api.nvim_list_wins()
        local cur_win = vim.api.nvim_get_current_win()
        local bufs_before = {}
        for _, win in ipairs(wins_before) do
          bufs_before[win] = vim.api.nvim_win_get_buf(win)
        end
        execute(function(result, err)
          vim.schedule(function()
            -- close panes the tool created
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if not vim.tbl_contains(wins_before, win) and vim.api.nvim_win_is_valid(win) then
                pcall(vim.api.nvim_win_close, win, true)
              end
            end
            -- restore buffers that were swapped out of existing windows
            for win, buf in pairs(bufs_before) do
              if
                vim.api.nvim_win_is_valid(win)
                and vim.api.nvim_buf_is_valid(buf)
                and vim.api.nvim_win_get_buf(win) ~= buf
              then
                pcall(vim.api.nvim_win_set_buf, win, buf)
              end
            end
            if vim.api.nvim_win_is_valid(cur_win) then
              pcall(vim.api.nvim_set_current_win, cur_win)
            end
          end)
          cb(result, err)
        end, args)
      end
    end

    local registry = require("mcp-tools.registry")
    for _, tool_name in ipairs({ "dap_set_breakpoint", "dap_run_to" }) do
      local original = registry._tools[tool_name]
      if original and original.execute then
        registry.register({
          name = original.name,
          description = original.description,
          args = original.args,
          execute = preserve_windows(original.execute),
        })
      end
    end

    -- mcp-tools pcalls dap.focus_frame() on every pause. When the session has no
    -- current frame (common on multi-threaded stops, e.g. .NET), nvim-dap opens
    -- an INTERACTIVE threads float (ft=dap-float) instead of jumping to source:
    -- a centered pane that steals focus and is never closed when an agent drives
    -- the session. Suppress that float branch; keep normal jump-to-frame.
    local dap = require("dap")
    local orig_focus_frame = dap.focus_frame
    dap.focus_frame = function(...)
      local session = dap.session()
      if session and not session.current_frame then
        return -- would open the interactive threads float; useless when agent-driven
      end
      return orig_focus_frame(...)
    end

    -- Belt and braces: close any stray dap float windows when a session ends
    local function close_dap_floats()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dap-float" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end
    dap.listeners.after.event_terminated["mcp_tools_cleanup"] = close_dap_floats
    dap.listeners.after.event_exited["mcp_tools_cleanup"] = close_dap_floats

    -- Register the MCP bridge with EXTERNAL agent processes (e.g. running in
    -- herdr panes). The bridge uses a random port + per-start auth token, so
    -- registration is pushed at runtime.
    --
    -- opencode: start it with a fixed port: `opencode --port 4096`
    --   (or `opencode serve --port 4096` + `opencode attach http://127.0.0.1:4096`).
    --   Default target: vim.g.mcp_tools_opencode_url (default http://127.0.0.1:4096),
    --   overridable per call: `:McpToolsRegister http://127.0.0.1:<port>`.
    -- claude code: registered via `claude mcp add` (local scope, current project).
    --   Disable with: vim.g.mcp_tools_claude = false
    local bridge = require("mcp-tools.bridge")

    local function resolve_opencode_url(url)
      if url and url ~= "" then
        return url
      end
      return vim.g.mcp_tools_opencode_url or "http://127.0.0.1:4096"
    end

    -- Register with Claude Code via its CLI (writes local-scope config for the
    -- current project into ~/.claude.json). The entry is refreshed on every
    -- nvim start because the bridge token rotates.
    local function register_with_claude()
      if vim.g.mcp_tools_claude == false or vim.fn.executable("claude") ~= 1 then
        return
      end
      local port, token = bridge.get_port(), bridge.get_auth_token()
      if not port or not token then
        return
      end
      local cwd = vim.fn.getcwd()
      local url = ("http://127.0.0.1:%d"):format(port)
      local function add()
        vim.system(
          { "claude", "mcp", "add", "nvim-tools", url, "--transport", "http", "-s", "local", "-H", "Authorization: Bearer " .. token },
          { cwd = cwd },
          function(result)
            vim.schedule(function()
              if result.code == 0 then
                vim.notify("[mcp-tools] nvim-tools registered with claude code (project: " .. cwd .. ")", vim.log.levels.INFO)
              else
                vim.notify("[mcp-tools] claude mcp add failed: " .. vim.trim(result.stderr or result.stdout or ""), vim.log.levels.WARN)
              end
            end)
          end
        )
      end
      -- remove the stale entry first (token rotates every nvim start)
      vim.system({ "claude", "mcp", "remove", "nvim-tools" }, { cwd = cwd }, function()
        vim.schedule(add)
      end)
    end

    -- Push registration to an external opencode server's POST /mcp endpoint.
    local function push_registration(retries, url)
      url = resolve_opencode_url(url)
      local port, token = bridge.get_port(), bridge.get_auth_token()
      if not port or not token then
        return
      end
      local body = vim.json.encode({
        name = "nvim-tools",
        config = {
          type = "remote",
          url = ("http://127.0.0.1:%d"):format(port),
          headers = { Authorization = "Bearer " .. token },
        },
      })
      vim.system(
        { "curl", "-s", "-X", "POST", "-H", "Content-Type: application/json", "-d", body, url .. "/mcp" },
        {},
        function(result)
          vim.schedule(function()
            local ok, response = pcall(vim.json.decode, result.stdout or "")
            local entry = ok and type(response) == "table" and response["nvim-tools"] or nil
            if result.code == 0 and entry and entry.status == "connected" then
              vim.notify("[mcp-tools] nvim-tools registered with opencode at " .. url, vim.log.levels.INFO)
            elseif retries > 0 then
              vim.defer_fn(function()
                push_registration(retries - 1, url)
              end, 5000)
            else
              local reason = (entry and entry.error) or "server unreachable"
              vim.notify(
                ("[mcp-tools] Could not register with opencode at %s (%s). Start opencode with a fixed port (e.g. `opencode --port 4096`) and run :McpToolsRegister"):format(
                  url,
                  reason
                ),
                vim.log.levels.WARN
              )
            end
          end)
        end
      )
    end

    local function start_bridge(retries, url)
      if bridge.is_running() then
        return
      end
      bridge.start({
        nvim_socket = vim.v.servername,
        on_ready = function()
          push_registration(retries, url)
          register_with_claude()
        end,
      })
    end

    vim.api.nvim_create_user_command("McpToolsRegister", function(opts)
      local url = opts.args ~= "" and opts.args or nil
      if bridge.is_running() then
        push_registration(0, url)
        register_with_claude()
      else
        start_bridge(0, url)
      end
    end, {
      nargs = "?",
      desc = "Push nvim-tools MCP registration to external opencode [url] and claude code",
    })

    -- Kill the bridge when nvim exits so it doesn't outlive its editor
    vim.api.nvim_create_autocmd("VimLeave", {
      callback = function()
        pcall(bridge.stop)
      end,
    })

    -- Start the bridge at startup and retry registration for ~30s in case
    -- opencode is already serving. Use :McpToolsRegister if it starts later.
    start_bridge(6)
  end,
}
