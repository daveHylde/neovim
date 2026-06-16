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

      -- GOTO
      table.insert(keys, {
        "<M-n>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(1)
        end,
        desc = "Goto #1",
      })
      table.insert(keys, {
        "<M-e>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(2)
        end,
        desc = "Goto #2",
      })
      table.insert(keys, {
        "<M-o>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(3)
        end,
        desc = "Goto #3",
      })
      table.insert(keys, {
        "<M-i>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(4)
        end,
        desc = "Goto #4",
      })

      table.insert(keys, {
        "<leader>hn",
        function()
          require("harpoon"):list():replace_at(1)
        end,
        desc = "Replace Harpoon slot 1",
      })
      table.insert(keys, {
        "<leader>he",
        function()
          require("harpoon"):list():replace_at(2)
        end,
        desc = "Replace Harpoon slot 2",
      })
      table.insert(keys, {
        "<leader>ho",
        function()
          require("harpoon"):list():replace_at(3)
        end,
        desc = "Replace Harpoon slot 3",
      })
      table.insert(keys, {
        "<leader>hi",
        function()
          require("harpoon"):list():replace_at(4)
        end,
        desc = "Replace Harpoon slot 4",
      })

      -- Remove at specific positions
      table.insert(keys, {
        "<leader>hN",
        function()
          require("harpoon"):list():remove_at(1)
        end,
        desc = "Remove Harpoon slot 1",
      })
      table.insert(keys, {
        "<leader>hE",
        function()
          require("harpoon"):list():remove_at(2)
        end,
        desc = "Remove Harpoon slot 2",
      })
      table.insert(keys, {
        "<leader>hO",
        function()
          require("harpoon"):list():remove_at(3)
        end,
        desc = "Remove Harpoon slot 3",
      })
      table.insert(keys, {
        "<leader>hI",
        function()
          require("harpoon"):list():remove_at(4)
        end,
        desc = "Remove Harpoon slot 4",
      })

      return keys
    end,
  },
}
