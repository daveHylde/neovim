return {
  {
    "coder/claudecode.nvim",
    lazy = false,
    opts = {
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.40,
      },
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
      },
    },
    keys = {
      {
        "<C-y>",
        "<cmd>ClaudeCode<cr>",
        desc = "Toggle Claude",
        mode = { "n", "i", "v" },
      },
    },
  },
}
