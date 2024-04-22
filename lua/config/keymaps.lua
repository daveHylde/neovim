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

-- DAP
vim.keymap.set("n", "<leader>dEs", function()
  require("dap").set_exception_breakpoints()
end, { desc = "Stop on exceptions" })
vim.keymap.set("n", "<leader>dEc", function()
  require("dap").set_exception_breakpoints({})
end, { desc = "Don't stop on exceptions" })
vim.keymap.set("n", "<leader>dx", function()
  require("dap").clear_breakpoints()
end, { desc = "Clear all breakpoints" })
vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Continue" })
vim.keymap.set("n", "<F10>", function()
  require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<F11>", function()
  require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<F12>", function()
  require("dap").step_over()
end, { desc = "Step Over" })

-- undotree
vim.keymap.set("n", "<leader>uu", function()
  vim.cmd("UndotreeToggle")
  vim.cmd("UndotreeFocus")
end, { desc = "Toggle Undotree" })

-- Move to window using the <alt> yneo keys
vim.keymap.set("n", "<M-y>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<M-n>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<M-e>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<M-o>", "<C-w>l", { desc = "Go to Right Window", remap = true })
