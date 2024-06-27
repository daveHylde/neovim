local util = require("lspconfig.util")

return {
  { "Hoffs/omnisharp-extended-lsp.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      document_highlight = { enabled = false },
      ---@type lspconfig.options
      servers = {
        tsserver = {
          root_dir = util.root_pattern("package.json", ".git", "tsconfig.base.json"),
          keys = {
            { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>cR", "<cmd>TypescriptRenameFile<CR>",      desc = "Rename File" },
          },
        },
        angularls = {
          root_dir = util.root_pattern("package.json", "angular.json", "project.json"), -- This is for monorepo's
          filetypes = { "html", "typescript", "typescriptreact", "angular" },
        },
        omnisharp = {
          filetypes = { "cs" },
          enable_roslyn_analyzers = true,
        },
        lua_ls = {
          cmd = { "/etc/profiles/per-user/david/bin/lua-language-server" },
        }
      },
    },
  },
}
