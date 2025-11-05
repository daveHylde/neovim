return {
  "hrsh7th/nvim-cmp",
  dependencies = { "hrsh7th/cmp-emoji" },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

    table.insert(opts.sources, { name = "easy-dotnet" })
  end,
}
