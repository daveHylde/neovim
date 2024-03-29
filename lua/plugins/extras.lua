return {
  {
    "Equilibris/nx.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    opts = {
      nx_cmd_root = "npx nx",
    },
    keys = {
      { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
    },
  },
  { "gpanders/editorconfig.nvim" },
  { "tpope/vim-dotenv", cmd = "Dotenv" },
  { "jlcrochet/vim-razor" },
  { "garyhurtz/cmp_bulma.nvim", opts = {} },
  { "3rd/image.nvim", opts = {} },
  { "numToStr/Comment.nvim", lazy = false },
}
