local inside_herdr = vim.env.HERDR_ENV == "1"

local nav_keys = { left = "<C-Left>", down = "<C-Down>", up = "<C-Up>", right = "<C-Right>" }
local resize_keys = { left = "<M-Left>", down = "<M-Down>", up = "<M-Up>", right = "<M-Right>" }

local function term_nav(fn)
  return ("<C-\\><C-n><cmd>lua require('herdr-splits').%s()<cr>"):format(fn)
end

return {
  {
    "lmilojevicc/herdr-splits.nvim",
    cond = inside_herdr,
    event = "VeryLazy",
    opts = {
      nav_keys = nav_keys,
      resize_keys = resize_keys,
    },
    keys = {
      { nav_keys.left, function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left" },
      { nav_keys.down, function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down" },
      { nav_keys.up, function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up" },
      { nav_keys.right, function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right" },
      { resize_keys.left, function() require("herdr-splits").resize_left() end, desc = "Resize left" },
      { resize_keys.down, function() require("herdr-splits").resize_down() end, desc = "Resize down" },
      { resize_keys.up, function() require("herdr-splits").resize_up() end, desc = "Resize up" },
      { resize_keys.right, function() require("herdr-splits").resize_right() end, desc = "Resize right" },
      { nav_keys.left, term_nav("move_cursor_left"), mode = "t", desc = "Navigate left" },
      { nav_keys.down, term_nav("move_cursor_down"), mode = "t", desc = "Navigate down" },
      { nav_keys.up, term_nav("move_cursor_up"), mode = "t", desc = "Navigate up" },
      { nav_keys.right, term_nav("move_cursor_right"), mode = "t", desc = "Navigate right" },
    },
  },

  {
    "ctbaum/herdr-agents.nvim",
    cond = inside_herdr,
    lazy = false,
    dependencies = {
      { "coder/claudecode.nvim", dependencies = { "folke/snacks.nvim" } },
    },
    opts = {
      claude = { enabled = true },
      codex = { enabled = false },
    },
    keys = {
      { "<C-y>", function() require("herdr-agents").open("claude") end, mode = { "n", "t" }, desc = "Open/focus Claude pane" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeHerdrSendSelection<cr>", mode = "v", desc = "Send selection" },
      { "<leader>aA", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  {
    "makyinmars/herdr-context.nvim",
    cond = inside_herdr,
    lazy = false,
    opts = { remember_target = "workspace" },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ac", function() require("herdr-context").compose() end, mode = { "n", "v" }, desc = "Compose context" },
      { "<leader>ap", function() require("herdr-context").prompt() end, mode = { "n", "v" }, desc = "Prompt with context" },
      { "<leader>ay", function() require("herdr-context").reference() end, mode = { "n", "v" }, desc = "Send reference" },
      { "<leader>aY", function() require("herdr-context").send() end, mode = { "n", "v" }, desc = "Send context" },
      { "<leader>ad", function() require("herdr-context").diagnostics() end, mode = { "n", "v" }, desc = "Send diagnostics" },
      { "<leader>at", function() require("herdr-context").select_target() end, desc = "Select agent" },
      { "<leader>aa", function() require("herdr-context").agents() end, desc = "Toggle agent drawer" },
      { "<leader>ar", function() require("herdr-context").refresh() end, desc = "Refresh agents" },
    },
  },
}