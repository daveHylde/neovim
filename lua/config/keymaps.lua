-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Remove lazyvim defaults
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "gc")
