return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<M-Left>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<M-Down>", "<cmd>TmuxNavigateDown<cr>" },
    { "<M-Up>", "<cmd>TmuxNavigateUp<cr>" },
    { "<M-Right>", "<cmd>TmuxNavigateRight<cr>" },
    { "<M-p>", "<cmd>TmuxNavigatePrevious<cr>" },
  },
}
