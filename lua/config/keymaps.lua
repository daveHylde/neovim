-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window navigation with Ctrl+arrows
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window" })

-- Navigate away from Claude Code
vim.keymap.set("n", "<C-y>", "<C-w>p", { desc = "Go to Previous Window" })

-- Move to window using the <alt> yneo keys
vim.keymap.set("n", "<c-Left>", ":TmuxNavigateLeft<CR>", { desc = "Go to Left Window", silent = true, remap = true })
vim.keymap.set("n", "<c-Down>", ":TmuxNavigateDown<CR>", { desc = "Go to Lower Window", silent = true, remap = true })
vim.keymap.set("n", "<c-Up>", ":TmuxNavigateUp<CR>", { desc = "Go to Upper Window", silent = true, remap = true })
vim.keymap.set("n", "<c-Right>", ":TmuxNavigateRight<CR>", { desc = "Go to Right Window", silent = true, remap = true })
vim.keymap.set(
  "n",
  "<c-p>",
  ":TmuxNavigatePrevious<CR>",
  { desc = "Go to Previous Window", silent = true, remap = true }
)
