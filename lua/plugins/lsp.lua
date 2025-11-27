return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      eslint = {},
      -- HTML LSP for Razor file completions and formatting
      html = {
        filetypes = { "html", "razor", "cshtml" },
      },
    },
    setup = {
      eslint = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            local filetype = vim.bo[bufnr].filetype

            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            elseif client.name == "html" and filetype == "razor" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end,
        })
      end,
    },
  },
}
