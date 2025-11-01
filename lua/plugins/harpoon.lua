return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>ha",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>hc",
          function()
            require("harpoon"):list():clear()
          end,
          desc = "Clear list",
        },
        {
          "<leader>hh",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<M-" .. i .. ">",
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
          remap = true,
          silent = true,
        })
      end
      return keys
    end,
  },
}
