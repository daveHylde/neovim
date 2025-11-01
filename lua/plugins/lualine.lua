return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      require("easy-dotnet.ui-modules.jobs").lualine,
      icon = "󰘐",
    })
    table.insert(opts.sections.lualine_x, "encoding")
  end,
}
