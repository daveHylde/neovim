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

-- Prevent saving files in /tmp
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("^/tmp/") then
      vim.api.nvim_err_writeln("Saving files in /tmp is not allowed!")
      vim.cmd("setlocal nomodified")
      vim.cmd("abort")
    end
  end,
})

-- Prevent prompt to save files in /tmp on quit
vim.api.nvim_create_autocmd({ "QuitPre", "BufDelete" }, {
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:match("^/tmp/") then
        vim.api.nvim_buf_set_option(buf, "modified", false)
      end
    end
  end,
})
