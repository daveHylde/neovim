return {
  "rcarriga/nvim-dap-ui",
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.80 },
          { id = "easy-dotnet_cpu", size = 0.05 },
          { id = "easy-dotnet_mem", size = 0.05 },
          { id = "breakpoints", size = 0.1 },
        },
        size = 50,
        position = "left",
      },
      {
        elements = {
          { id = "console", size = 1.0 },
        },
        size = 15,
        position = "bottom",
      },
    },
    controls = {
      element = "console",
      enabled = true,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
      },
    },
  },
}
