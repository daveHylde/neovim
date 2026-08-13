-- Make Neovim follow lazygit when it switches worktree (or repo).
--
-- lazygit changes the working directory of *its own process*, so nothing is
-- communicated back to Neovim. Two observed signals are combined here:
--
--   1. `/proc/<pid>/cwd` of our lazygit child is the source of truth. It is
--      unambiguous (it is *our* lazygit, not another Neovim's) and it covers
--      both worktree switches and repo switches (`<c-r>`).
--   2. lazygit rewrites `state.yml` *at switch time* (not on exit), in place,
--      promoting the new worktree to `recentrepos[0]`. Watching that file gives
--      an instant trigger instead of waiting out a poll interval, and lets us
--      recover a switch made in the last moments before lazygit exited, when
--      /proc is already gone.
--
-- state.yml is global, so it is only ever used as a *trigger* (re-read /proc) or,
-- at exit, gated behind a same-repository check.
--
-- Linux only (needs /proc). Fires `User LazygitWorktreeChanged` on success.

local M = {}

local uv = vim.uv or vim.loop
local POLL_MS = 1000 -- safety net; state.yml watching is the fast path

---@param pid integer
---@return string?
local function proc_comm(pid)
  local fd = io.open("/proc/" .. pid .. "/comm", "r")
  if not fd then
    return nil
  end
  local name = fd:read("l")
  fd:close()
  return name
end

---@param pid integer
---@return string?
local function proc_cwd(pid)
  local target = uv.fs_readlink("/proc/" .. pid .. "/cwd")
  return target and vim.fs.normalize(target) or nil
end

---@param pid integer
---@return integer[]
local function proc_children(pid)
  local fd = io.open(("/proc/%d/task/%d/children"):format(pid, pid), "r")
  if not fd then
    return {}
  end
  local line = fd:read("l") or ""
  fd:close()
  local children = {}
  for child in line:gmatch("%d+") do
    table.insert(children, tonumber(child))
  end
  return children
end

-- The terminal job is usually lazygit itself, but tolerate a shell wrapper.
---@param pid integer
---@param depth? integer
---@return integer?
local function find_lazygit(pid, depth)
  depth = depth or 2
  if proc_comm(pid) == "lazygit" then
    return pid
  end
  if depth <= 0 then
    return nil
  end
  for _, child in ipairs(proc_children(pid)) do
    local found = find_lazygit(child, depth - 1)
    if found then
      return found
    end
  end
  return nil
end

--- Path of lazygit's state file, which is separate from its config dir
--- (`lazygit -cd` prints the config dir, so it cannot be used here).
---@return string?
local function state_file()
  local dir = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
  local path = vim.fs.normalize(dir .. "/lazygit/state.yml")
  return uv.fs_stat(path) and path or nil
end

--- Most recently opened repo/worktree according to lazygit's state file.
---@return string?
local function state_repo()
  local path = state_file()
  local fd = path and io.open(path, "r")
  if not fd then
    return nil
  end
  local found, in_list ---@type string?, boolean
  for line in fd:lines() do
    if in_list then
      local repo = line:match("^%s*%-%s+(.+)%s*$")
      found = repo and vim.fs.normalize((repo:gsub('^"(.*)"$', "%1"))) or nil
      break -- only the first entry is current
    elseif line:match("^recentrepos:") then
      in_list = true
    end
  end
  fd:close()
  return found
end

---@param dir string
---@return boolean
local function is_git_root(dir)
  local git = dir .. "/.git"
  -- a linked worktree has a `.git` file, the main worktree a directory
  return vim.fn.isdirectory(git) == 1 or vim.fn.filereadable(git) == 1
end

--- The shared `.git` dir, used to tell worktrees of one repo apart from
--- unrelated repos.
---@param dir string
---@return string?
local function git_common_dir(dir)
  local ok, res = pcall(function()
    return vim
      .system({ "git", "-C", dir, "rev-parse", "--path-format=absolute", "--git-common-dir" }, { text = true })
      :wait(2000)
  end)
  if not ok or res.code ~= 0 then
    return nil
  end
  return vim.fs.normalize(vim.trim(res.stdout))
end

--- Re-point a buffer's window(s) at `path`, keeping the cursor position.
---@param buf integer
---@param path string
local function replace_buf(buf, path)
  local newbuf = vim.fn.bufadd(path)
  vim.fn.bufload(newbuf)
  vim.bo[newbuf].buflisted = true

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      local cursor = vim.api.nvim_win_get_cursor(win)
      vim.api.nvim_win_set_buf(win, newbuf)
      local lines = vim.api.nvim_buf_line_count(newbuf)
      pcall(vim.api.nvim_win_set_cursor, win, { math.min(cursor[1], lines), cursor[2] })
    end
  end

  pcall(vim.api.nvim_buf_delete, buf, {})
end

--- Shut down language servers left rooted in the worktree we moved away from.
--- Without this, every switch strands a server (expensive for e.g. roslyn).
---@param old_root string
local function stop_orphan_clients(old_root)
  vim.defer_fn(function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      local root = client.root_dir and vim.fs.normalize(client.root_dir)
      local rooted_in_old = root and (root == old_root or vim.startswith(root, old_root .. "/"))
      if rooted_in_old and next(client.attached_buffers or {}) == nil then
        pcall(function()
          client:stop()
        end)
      end
    end
  end, 2000)
end

--- Move Neovim (cwd + buffers) to `new_root`.
---@param new_root string
---@return boolean moved
function M.follow(new_root)
  new_root = vim.fs.normalize(new_root)
  local old_root = vim.fs.normalize(uv.cwd() or "")

  if new_root == old_root or vim.fn.isdirectory(new_root) == 0 or not is_git_root(new_root) then
    return false
  end

  local prefix = old_root .. "/"
  local moves, dirty, missing = {}, 0, 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and name ~= "" then
      name = vim.fs.normalize(name)
      if vim.startswith(name, prefix) then
        local target = new_root .. "/" .. name:sub(#prefix + 1)
        if vim.bo[buf].modified then
          dirty = dirty + 1
        elseif vim.fn.filereadable(target) == 1 then
          moves[buf] = target
        else
          missing = missing + 1
        end
      end
    end
  end

  vim.cmd.cd(vim.fn.fnameescape(new_root))
  for buf, target in pairs(moves) do
    replace_buf(buf, target)
  end
  vim.cmd.checktime()
  stop_orphan_clients(old_root)

  local msg = { ("Followed lazygit to `%s`"):format(vim.fn.fnamemodify(new_root, ":~")) }
  table.insert(msg, ("- %d buffer(s) moved"):format(vim.tbl_count(moves)))
  if dirty > 0 then
    table.insert(msg, ("- %d modified buffer(s) left alone"):format(dirty))
  end
  if missing > 0 then
    table.insert(msg, ("- %d buffer(s) not present in the new worktree"):format(missing))
  end
  vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, { title = "lazygit worktree" })

  vim.api.nvim_exec_autocmds("User", {
    pattern = "LazygitWorktreeChanged",
    data = { old = old_root, new = new_root },
  })
  return true
end

--- Follow the repo named in lazygit's state file, if it is a worktree of the
--- repo we are currently in. Used when lazygit has already exited (so /proc is
--- gone); also handy manually if a switch is ever missed.
---@param ignore? string a path to treat as "no change" (where lazygit started)
---@return boolean moved
function M.follow_state(ignore)
  local cwd = vim.fs.normalize(uv.cwd() or "")
  local repo = state_repo()
  if not repo or repo == cwd or repo == ignore or vim.fn.isdirectory(repo) == 0 then
    return false
  end
  local common = git_common_dir(cwd)
  if not common or common ~= git_common_dir(repo) then
    return false -- a different repository: another lazygit wrote this
  end
  return M.follow(repo)
end

--- `Snacks.terminal` keys its instance cache on cwd, so after a follow the
--- running lazygit can never be toggled back — it would linger as an
--- unreachable background process. Wipe it once it is out of sight.
---@param buf integer
local function wipe_when_hidden(buf)
  vim.api.nvim_create_autocmd({ "BufHidden", "BufWinLeave" }, {
    buffer = buf,
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) and vim.fn.bufwinid(buf) == -1 then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end)
    end,
  })
end

--- Watch a running lazygit for cwd changes.
---@param buf integer terminal buffer, watched so we stop when it goes away
---@param pid integer
local function watch(buf, pid)
  local last = proc_cwd(pid)
  if not last then
    return
  end
  local start = last
  local stopped = false

  local timer, fs_event = assert(uv.new_timer()), uv.new_fs_event()

  local function stop()
    if stopped then
      return
    end
    stopped = true
    if not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    if fs_event and not fs_event:is_closing() then
      fs_event:stop()
      fs_event:close()
    end
  end

  -- read our own lazygit's cwd; state.yml only ever acts as a trigger
  local function check()
    if stopped then
      return
    end
    local cwd = proc_cwd(pid)
    if not cwd or not vim.api.nvim_buf_is_valid(buf) then
      return stop()
    end
    if cwd ~= last then
      last = cwd
      if M.follow(cwd) then
        wipe_when_hidden(buf)
      end
    end
  end

  timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(check))

  local state = state_file()
  if fs_event and state then
    -- lazygit rewrites state.yml in place, so the watch survives the write
    fs_event:start(state, {}, vim.schedule_wrap(check))
  end

  -- lazygit exited: /proc is gone, so fall back to state.yml for a switch we
  -- may have missed, but only if it names a worktree of the same repository.
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    once = true,
    callback = function()
      stop()
      M.follow_state(start)
    end,
  })
end

function M.setup()
  if not uv.fs_stat("/proc/self/cwd") then
    return -- /proc required
  end

  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("lazygit_worktree", { clear = true }),
    callback = function(ev)
      local chan = vim.b[ev.buf].terminal_job_id
      local ok, job_pid = pcall(vim.fn.jobpid, chan)
      if not ok then
        return
      end
      -- lazygit may not have exec'd yet when TermOpen fires
      vim.defer_fn(function()
        local pid = find_lazygit(job_pid)
        if pid and vim.api.nvim_buf_is_valid(ev.buf) then
          watch(ev.buf, pid)
        end
      end, 300)
    end,
  })
end

return M
