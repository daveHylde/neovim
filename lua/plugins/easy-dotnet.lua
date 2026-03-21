return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "snacks.nvim" },
  config = function()
    local dotnet = require("easy-dotnet")

    -- Options are not required
    dotnet.setup({
      managed_terminal = {
        auto_hide = true, -- auto hides terminal if exit code is 0
        auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
      },
      lsp = {
        enabled = false, -- Disable builtin roslyn lsp - using seblyng/roslyn.nvim instead
        roslynator_enabled = true, -- Automatically enable roslynator analyzer
        analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
        config = {},
      },
      debugger = {
        bin_path = vim.fn.expand("~/.local/share/nvim/mason/bin/netcoredbg"),
        console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" or "externalTerminal"
        apply_value_converters = true, -- Apply value converters for better debugging
        auto_register_dap = true,
        mappings = {
          open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
        },
      },
      ---@type TestRunnerOptions
      test_runner = {
        auto_start_testrunner = true, -- Auto-start when server starts
        hide_legend = false, -- Hide the keymap legend
        ---@type "split" | "vsplit" | "float" | "buf"
        viewmode = "float",
        ---@type number|nil
        vsplit_width = nil,
        ---@type string|nil "topleft" | "topright"
        vsplit_pos = nil,
        enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
        noBuild = false,
        icons = {
          passed = "",
          skipped = "",
          failed = "",
          success = "",
          reload = "",
          test = "",
          sln = "󰘐",
          project = "󰘐",
          dir = "",
          package = "",
          class = "", -- Missing icon added
          build_failed = "󰒡", -- Missing icon added
        },
        mappings = {
          run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
          peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
          filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
          debug_test = { lhs = "<leader>d", desc = "debug test" },
          go_to_file = { lhs = "g", desc = "go to file" },
          run_all = { lhs = "<leader>R", desc = "run all tests" },
          run = { lhs = "<leader>r", desc = "run test" },
          peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
          expand = { lhs = "o", desc = "expand" },
          expand_node = { lhs = "E", desc = "expand node" },
          expand_all = { lhs = "-", desc = "expand all" },
          collapse_all = { lhs = "W", desc = "collapse all" },
          close = { lhs = "q", desc = "close testrunner" },
          refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
          get_build_errors = { lhs = "<leader>e", desc = "get build errors" }, -- Added mapping
          debug_test_from_buffer = { lhs = "<leader>d", desc = "debug test from buffer" }, -- Added mapping
          cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" }, -- Added mapping
        },
        --- Optional table of extra args e.g "--blame crash"
        additional_args = {},
      },
      new = {
        project = {
          prefix = "sln", -- "sln" | "none"
        },
      },
      ---@param action "test" | "restore" | "build" | "run"
      terminal = function(path, action, args)
        args = args or ""
        local commands = {
          run = function()
            return string.format("dotnet run --project %s %s", path, args)
          end,
          test = function()
            return string.format("dotnet test %s %s", path, args)
          end,
          restore = function()
            return string.format("dotnet restore %s %s", path, args)
          end,
          build = function()
            return string.format("dotnet build %s %s", path, args)
          end,
          watch = function()
            return string.format("dotnet watch --project %s %s", path, args)
          end,
        }
        local command = commands[action]()
        if require("easy-dotnet.extensions").isWindows() == true then
          command = command .. "\r"
        end
        vim.cmd("vsplit")
        vim.cmd("term " .. command)
      end,
      csproj_mappings = true,
      fsproj_mappings = false,
      auto_bootstrap_namespace = {
        --block_scoped, file_scoped
        type = "block_scoped",
        enabled = true,
        use_clipboard_json = {
          behavior = "never", --'auto' | 'prompt' | 'never',
          register = "+", -- which register to check
        },
      },
      server = {
        ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
        log_level = nil,
      },
      -- choose which picker to use with the plugin
      -- possible values are "telescope" | "fzf" | "snacks" | "basic"
      -- if no picker is specified, the plugin will determine
      -- the available one automatically with this priority:
      -- telescope -> fzf -> snacks ->  basic
      picker = "snacks",
      background_scanning = true,
      notifications = {
        --Set this to false if you have configured lualine to avoid double logging
        handler = false,
      },
      diagnostics = {
        default_severity = "error",
        setqflist = false,
      },
    })
  end,
}
