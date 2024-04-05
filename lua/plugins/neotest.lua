return {
  { "nvim-neotest/neotest-plenary" },
  { "Issafalcon/neotest-dotnet" },
  { "thenbe/neotest-playwright" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        "neotest-plenary",
        ["neotest-dotnet"] = {
          dap = { justMyCode = true },
          dotnet_additional_args = {
            '--collect:"XPlat Code Coverage"',
          },
          discovery_root = "solution",
        },
      },
    },
  },
}
