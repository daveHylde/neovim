-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.swapfile = false
vim.g.minipairs_disable = true
vim.g.autoformat = false

-- Hide Roslyn's virtual/generated tree from completion/file prompts
-- (e.g. a literal folder named `roslyn-source-generated:` in the project root)
vim.opt.wildignore:append({
  "roslyn-source-generated:",
  "roslyn-source-generated:/*",
  "*/roslyn-source-generated:/*",
})

-- Keep editor artifacts out of the repo/worktree (also avoids weird virtual-buffer names creating folders)
local state = vim.fn.stdpath("state")
vim.opt.directory = { state .. "/swap//" }
vim.opt.backupdir = { state .. "/backup//" }
vim.opt.undodir = { state .. "/undo//" }
vim.opt.undofile = true

-- Disable automatic root directory detection
-- Keep the root directory fixed to where nvim was opened
vim.g.root_spec = { "cwd" }
