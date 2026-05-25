return {
  -- Clean up render-markdown: keep bold/icons, remove background colors
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        -- Keep icons and bold text, but remove background line highlighting
        backgrounds = {},
      },
    },
  },

  -- Remove markdownlint-cli2 warnings from nvim-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
        ["markdown.mdx"] = {},
      },
    },
  },

  -- Remove markdownlint-cli2 warnings from none-ls
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if opts.sources then
        opts.sources = vim.tbl_filter(function(source)
          -- Filter out markdownlint diagnostics source by name
          local name = type(source) == "table" and source.name or tostring(source)
          return name ~= "markdownlint_cli2" and name ~= "markdownlint"
        end, opts.sources)
      end
    end,
  },
}
