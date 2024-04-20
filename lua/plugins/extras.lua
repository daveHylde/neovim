local COLORIZER_OPTIONS = {
  RGB = true, -- #RGB hex codes
  RRGGBB = true, -- #RRGGBB hex codes
  names = false, -- "Name" codes like Blue
  RRGGBBAA = true, -- #RRGGBBAA hex codes
  rgb_fn = true, -- CSS rgb() and rgba() functions
  hsl_fn = true, -- CSS hsl() and hsla() functions
  css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
  css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
  mode = "background", -- Set the display mode.
}

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
  { "andreshazard/vim-freemarker" },
  { "garyhurtz/cmp_bulma.nvim", opts = {} },
  { "3rd/image.nvim", opts = {} },
  { "camdencheek/tree-sitter-dockerfile" },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      html = COLORIZER_OPTIONS,
      css = COLORIZER_OPTIONS,
      scss = COLORIZER_OPTIONS,
      razor = COLORIZER_OPTIONS,
    },
  },
  { "mbbill/undotree" },
}
