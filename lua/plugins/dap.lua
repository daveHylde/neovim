return {
  "mfussenegger/nvim-dap",
  opts = function()
    require("dap.ext.vscode").load_launchjs(nil, { netcoredbg = { "cs", "sln" } })
    require("dap").adapters["netcoredbg"] = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }
  end,
}
