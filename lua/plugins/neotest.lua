return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        require("neotest-dotnet")({
          dap = {
            justMyCode = false,
            adapter_name = "netcoredbg",
          },
           discovery_root = "solution",
        }),
      },
    },
  },
}
