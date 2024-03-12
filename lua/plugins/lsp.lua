local util = require("lspconfig.util")

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
      end)
    end,
  },
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- tsserver will be automatically installed with mason and loaded with lspconfig
      tsserver = {
        root_dir = util.root_pattern("package.json", ".git", "tsconfig.base.json"),
      },
      angularls = {
        root_dir = util.root_pattern("angular.json", "project.json"), -- This is for monorepo's
        filetypes = { "html", "typescript", "typescriptreact", "angular" },
      },
      eslint = {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      },
      csharp_ls = {
        cmd = { "/etc/profiles/per-user/david/bin/csharp-ls" },
      },
    },
  },
}
