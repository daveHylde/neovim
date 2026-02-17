-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufAdd", "BufNew", "BufReadPre", "BufEnter" }, {
  pattern = "*",
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("^roslyn%-source%-generated:") or bufname:match("/roslyn%-source%-generated:") then
      vim.bo[args.buf].buflisted = false
      vim.api.nvim_buf_delete(args.buf, { force = true })
    end
  end,
  desc = "Delete roslyn source-generated buffers immediately",
})
