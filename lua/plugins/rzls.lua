return {
  "tris203/rzls.nvim",
  dependencies = {
    "seblj/roslyn.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "razor", "cshtml" },
  init = function()
    -- Register Razor file types
    vim.filetype.add({
      extension = {
        razor = "razor",
        cshtml = "razor",
      },
    })
  end,
  config = function()
    -- Set up rzls with Mason path
    require("rzls").setup({
      path = vim.fn.expand("~/.local/share/nvim/mason/bin/rzls"),
    })

    -- Hide virtual CS files from buffers
    vim.api.nvim_create_autocmd("BufAdd", {
      pattern = "*__virtual.cs",
      callback = function(args)
        vim.bo[args.buf].buflisted = false
      end,
      desc = "Hide Razor virtual files from buffer list",
    })

    -- Rzls handlers are configured in lua/plugins/roslyn.lua
  end,
}

