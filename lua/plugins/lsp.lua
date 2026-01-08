return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      html = {
        filetypes = { "html", "razor", "cshtml" },
      },
      cssls = {
        filetypes = { "razor", "cshtml", "css", "scss", "less" },
      },
    },
  },
}
