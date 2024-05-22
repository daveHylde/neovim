return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-plenary",
    "Issafalcon/neotest-dotnet",
    "thenbe/neotest-playwright",
  },
  opts = {
    adapters = {
      "neotest-plenary",
      require("neotest-dotnet")({
        dap = {
          justMyCode = false,
          adapter_name = "netcoredbg",
        },
        dotnet_additional_args = {
          '--collect:"XPlat Code Coverage"',
        },
        discovery_root = "solution",
      }),
    },
  },
}
