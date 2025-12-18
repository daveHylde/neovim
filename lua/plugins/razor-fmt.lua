-- Razor file formatter using CSharpier for @code{} blocks and HTML
return {
  "daveHylde/razor-fmt",
  dependencies = { "nvim-lua/plenary.nvim", "stevearc/conform.nvim" },
  event = "VeryLazy",
  opts = {
    html = {
      max_attributes_per_line = 2
    },
  },
}
