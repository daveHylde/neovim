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
      "Nsidorenco/neotest-vstest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vstest")({
            dap_settings = {
              type = "netcoredbg",
            },
          }),
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
