-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.g.vscode then
  -- VSCode extension
else
  -- Move to window using the <alt> yneo keys
  vim.keymap.set("n", "<c-Left>", ":TmuxNavigateLeft<CR>", { desc = "Go to Left Window", silent = true, remap = true })
  vim.keymap.set("n", "<c-Down>", ":TmuxNavigateDown<CR>", { desc = "Go to Lower Window", silent = true, remap = true })
  vim.keymap.set("n", "<c-Up>", ":TmuxNavigateUp<CR>", { desc = "Go to Upper Window", silent = true, remap = true })
  vim.keymap.set(
    "n",
    "<c-Right>",
    ":TmuxNavigateRight<CR>",
    { desc = "Go to Right Window", silent = true, remap = true }
  )
  vim.keymap.set(
    "n",
    "<c-p>",
    ":TmuxNavigatePrevious<CR>",
    { desc = "Go to Previous Window", silent = true, remap = true }
  )

  -- Terminal mode navigation (for Claude Code and other terminals)
  vim.keymap.set("t", "<c-Left>", "<C-\\><C-n>:TmuxNavigateLeft<CR>", { desc = "Go to Left Window", silent = true })
  vim.keymap.set("t", "<c-Down>", "<C-\\><C-n>:TmuxNavigateDown<CR>", { desc = "Go to Lower Window", silent = true })
  vim.keymap.set("t", "<c-Up>", "<C-\\><C-n>:TmuxNavigateUp<CR>", { desc = "Go to Upper Window", silent = true })
  vim.keymap.set("t", "<c-Right>", "<C-\\><C-n>:TmuxNavigateRight<CR>", { desc = "Go to Right Window", silent = true })

  -- Resize window using <alt> arrow keys
  vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

  local dap = require("dap")
  vim.keymap.set({ "n", "v" }, "<F5>", function()
    dap.continue()
  end, { desc = "Continue" })
  vim.keymap.set({ "n", "v" }, "<F10>", function()
    dap.step_into()
  end, { desc = "Step Into" })
  vim.keymap.set({ "n", "v" }, "<F11>", function()
    dap.step_out()
  end, { desc = "Step Out" })
  vim.keymap.set({ "n", "v" }, "<F12>", function()
    dap.step_over()
  end, { desc = "Step Over" })
end
