-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.swapfile = false
vim.g.minipairs_disable = true
vim.g.autoformat = false

-- Disable automatic root directory detection
-- Keep the root directory fixed to where nvim was opened
vim.g.root_spec = { "cwd" }
