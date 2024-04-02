-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- visual mode
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv")

-- nx
vim.keymap.set("n", "<leader>nr", "<cmd>Telescope nx actions<CR>", {})
vim.keymap.set("n", "<leader>ng", "<cmd>Telescope nx generators<CR>", {})
vim.keymap.set("n", "<leader>nm", "<cmd>Telescope nx run_many<CR>", {})
vim.keymap.set("n", "<leader>na", "<cmd>Telescope nx affected<CR>", {})

-- dadbod
vim.api.nvim_set_keymap("n", "<leader>kk", "<cmd>DBUIToggle<cr>", { noremap = true, silent = true })
