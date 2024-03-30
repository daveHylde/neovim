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
  { "tpope/vim-dotenv",          cmd = "Dotenv" },
  { "jlcrochet/vim-razor" },
  { "garyhurtz/cmp_bulma.nvim",  opts = {} },
  { "3rd/image.nvim",            opts = {} },
  { "norcalli/nvim-colorizer.lua", 
    opts = {
      razor = {
        RGB      = true;         -- #RGB hex codes
        RRGGBB   = true;         -- #RRGGBB hex codes
        names    = false;         -- "Name" codes like Blue
        RRGGBBAA = true;        -- #RRGGBBAA hex codes
        rgb_fn   = true;        -- CSS rgb() and rgba() functions
        hsl_fn   = true;        -- CSS hsl() and hsla() functions
        css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode     = 'background'; -- Set the display mode.
      };
      html = {
        RGB      = true;         -- #RGB hex codes
        RRGGBB   = true;         -- #RRGGBB hex codes
        names    = false;         -- "Name" codes like Blue
        RRGGBBAA = true;        -- #RRGGBBAA hex codes
        rgb_fn   = true;        -- CSS rgb() and rgba() functions
        hsl_fn   = true;        -- CSS hsl() and hsla() functions
        css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode     = 'background'; -- Set the display mode.
      };
      scss = {
        RGB      = true;         -- #RGB hex codes
        RRGGBB   = true;         -- #RRGGBB hex codes
        names    = false;         -- "Name" codes like Blue
        RRGGBBAA = true;        -- #RRGGBBAA hex codes
        rgb_fn   = true;        -- CSS rgb() and rgba() functions
        hsl_fn   = true;        -- CSS hsl() and hsla() functions
        css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode     = 'background'; -- Set the display mode.
      };
      css = {
        RGB      = true;         -- #RGB hex codes
        RRGGBB   = true;         -- #RRGGBB hex codes
        names    = false;         -- "Name" codes like Blue
        RRGGBBAA = true;        -- #RRGGBBAA hex codes
        rgb_fn   = true;        -- CSS rgb() and rgba() functions
        hsl_fn   = true;        -- CSS hsl() and hsla() functions
        css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode     = 'background'; -- Set the display mode.
      };
    }
  },
  { "numToStr/Comment.nvim",     lazy = false },
}
