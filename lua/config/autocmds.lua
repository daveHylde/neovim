-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({
  "BufNewFile",
  "BufRead",
}, {
  pattern = "*.component.html",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(buf, "filetype", "angular.html")
  end,
})
