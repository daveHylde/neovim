-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.g.vscode then
  -- VSCode extension
else
  -- <c-arrow> navigation and <M-arrow> resizing now come from herdr-splits.nvim
  -- (see plugins/herdr.lua) — it crosses Neovim splits and Herdr panes as one layout.
  -- The old :TmuxNavigate* maps were dead: tmux isn't in the picture anymore.
  vim.keymap.set("n", "<c-p>", "<C-w>p", { desc = "Go to Previous Window", silent = true })

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

  -- Spell language picker
  local function pick_spell_lang()
    local languages = {
      { name = "English", code = "en" },
      { name = "Norwegian (Bokmål)", code = "nb" },
    }

    Snacks.picker.select(languages, {
      prompt = "Select spell language",
      format_item = function(item)
        local current = vim.opt.spelllang:get()[1] or "en"
        local indicator = item.code == current and " ●" or ""
        return item.name .. indicator
      end,
    }, function(item)
      if item then
        vim.opt.spelllang = item.code
        vim.opt.spell = true
        vim.notify("Spell language set to " .. item.name, vim.log.levels.INFO)
      end
    end)
  end

  vim.keymap.set("n", "<leader>ut", pick_spell_lang, { desc = "Select spell language" })

  -- Spell fix mappings
  vim.keymap.set("n", "zn", function()
    Snacks.picker.spelling()
  end, { desc = "Fix spelling (Snacks picker)" })
  vim.keymap.set("n", "zN", ":spellr<CR>", { desc = "Repeat last spelling fix in file", silent = true })

  -- QOL
  vim.keymap.set({ "n", "v" }, "<leader>cb", "<C-\\><C-n>:Dotnet build solution quickfix<CR>", { desc = "Dotnet build quickfix", silent = true })
end
