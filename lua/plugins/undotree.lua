return {
  "mbbill/undotree",
  keymaps = {
    vim.keymap.set("n", "<leader>uu", function()
      vim.cmd("UndotreeToggle")
      vim.cmd("UndotreeFocus")
    end, { desc = "Toggle Undotree" })
  }
}
