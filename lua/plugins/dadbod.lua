return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 50
    vim.g.db_ui_expanded_layout = 1
    vim.g.db_up_execute_on_save = 0
    vim.g.db_ui_auto_execute_table_helpers = 0

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        require("cmp").setup.buffer({
          sources = {
            { name = "vim-dadbod-completion" },
          },
        })
      end,
    })
  end,
}
