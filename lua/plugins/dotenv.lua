return {
  "ellisonleao/dotenv.nvim",
  lazy = false, -- Load on start
  config = function()
    require("dotenv").setup({
      enable_on_load = true, -- will load your .env file upon loading a buffer
      verbose = false, -- show error notification if .env file is not found and if .env is loaded
      file_name = ".env.local", -- will override the default file name '.env'
    })
  end,
}
