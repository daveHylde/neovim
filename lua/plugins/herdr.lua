local inside_herdr = vim.env.HERDR_ENV == "1"

-- Chords forwarded between Herdr and Neovim. These must match the
-- `[[keys.command]]` binds in ~/.config/herdr/config.toml: herdr-splits writes them
-- into a generated herdr-splits.conf so both sides agree on what to forward.
local nav_keys = { left = "<C-Left>", down = "<C-Down>", up = "<C-Up>", right = "<C-Right>" }
local resize_keys = { left = "<M-Left>", down = "<M-Down>", up = "<M-Up>", right = "<M-Right>" }

---Terminal-mode rhs: leave terminal mode first so `wincmd` applies, then navigate.
local function term_nav(fn)
  return ("<C-\\><C-n><cmd>lua require('herdr-splits').%s()<cr>"):format(fn)
end

return {
  -- Seamless <C-arrow> navigation and <M-arrow> resizing across Neovim splits and
  -- Herdr panes — the replacement for the old vim-aware C-arrow binds in
  -- ~/.config/tmux/tmux.conf. Herdr has no `if-shell "$is_vim"` equivalent, so the
  -- plugin reconstructs that decision from both sides.
  {
    "lmilojevicc/herdr-splits.nvim",
    cond = inside_herdr,
    -- setup() must run eagerly: it writes the generated herdr-splits.conf that tells
    -- the Herdr side which chords to forward. Lazy-loading it only from those same
    -- keys would deadlock — the conf wouldn't exist yet, so the keys would never
    -- arrive to trigger the load.
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

  -- Agents run in real Herdr panes, not in an nvim terminal split. claudecode.nvim is
  -- present purely as plumbing: herdr-agents drives it (`require("claudecode").setup`
  -- in herdr-agents/claude.lua) and would hard-error without it. It contributes no
  -- keymaps or UI of its own here — the LazyVim ai.claudecode extra stays disabled —
  -- but it is what keeps the IDE/MCP link alive, so @-mentions, selection tracking and
  -- in-editor diff review still work against the pane.
  {
    "ctbaum/herdr-agents.nvim",
    cond = inside_herdr,
    lazy = false,
    dependencies = {
      { "coder/claudecode.nvim", dependencies = { "folke/snacks.nvim" } },
    },
    opts = {
      claude = { enabled = true },
      codex = { enabled = false }, -- codex.nvim isn't installed
    },
    keys = {
      -- <C-y> used to toggle claudecode's terminal split; now it opens or focuses the
      -- Claude pane through Herdr.
      { "<C-y>", function() require("herdr-agents").open("claude") end, mode = { "n", "t" }, desc = "Open/focus Claude pane" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeHerdrSendSelection<cr>", mode = "v", desc = "Send selection" },
      { "<leader>aA", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- Stages code, symbols, hunks and diagnostics into the prompt of whichever Herdr
  -- agent is pinned (Herdr-side picker: prefix+shift+A) — including agents this config
  -- never launched, which is what herdr-agents alone can't reach.
  {
    "makyinmars/herdr-context.nvim",
    cond = inside_herdr,
    lazy = false, -- keeps :checkhealth herdr-context discoverable before first use
    -- Share the pinned target with Herdr's own picker instead of keeping a separate
    -- per-session choice on each side.
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
