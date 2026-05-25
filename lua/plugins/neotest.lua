return {
  { "nvim-neotest/neotest-plenary" },
  { "Nsidorenco/neotest-vstest" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "GustavEikaas/easy-dotnet.nvim",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("easy-dotnet.neotest"),
        },
        quickfix = {
          open = function()
            vim.cmd("Trouble quickfix")
          end,
          enabled = true,
        },
      })
    end,
  },
}
