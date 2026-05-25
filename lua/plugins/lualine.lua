return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  opts = function(_, opts)
    local dotnet = require("easy-dotnet")
    table.insert(opts.sections.lualine_x, {
      dotnet.lualine.jobs,
      icon = "󰘐",
    })
    table.insert(opts.sections.lualine_x, {
      dotnet.lualine.run_status,
      color    = dotnet.lualine.run_status_color,
      on_click = dotnet.lualine.run_status_click,
    })
    table.insert(opts.sections.lualine_x, "encoding")
  end,
}
