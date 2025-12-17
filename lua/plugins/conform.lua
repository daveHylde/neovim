return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      csproj = { "xmlformat" },
      xml = { "xmlformat" },
      razor = { "razor_fmt" },
    },
    formatters = {
      xmlformat = {
        command = "xmlformat",
      },
      csharpier = {
        command = "csharpier",
        args = { "format", "--write-stdout" },
        stdin = true,
      },
    },
  },
}
