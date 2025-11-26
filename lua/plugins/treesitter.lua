return {
  "nvim-treesitter/nvim-treesitter",
  ---@class lazyvim.TSConfig: TSConfig
  opts = {
    -- LazyVim config for treesitter
    indent = { enable = true }, ---@type lazyvim.TSFeat
    highlight = { enable = true }, ---@type lazyvim.TSFeat
    folds = { enable = true }, ---@type lazyvim.TSFeat
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "razor",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
}
