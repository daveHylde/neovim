return {
  "snacks.nvim",
  opts = {
    words = { enabled = false },
    notifier = {
      enabled = true,
      level = vim.log.levels.INFO,
      filter = function(msg)
        local banned_messages = { "No information available" }
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return false
          end
        end
        return true
      end,
    },
    scroll = {
      enabled = false, -- Disable scrolling animations
    },
    -- Required for opencode.nvim
    input = {},
    picker = {
      sources = {
        explorer = {
          layout = {
            preview = "main",
            auto_close = true,
          },
          win = {
            list = {
              keys = {
                ["A"] = "explorer_add_dotnet",
              },
            },
          },
          actions = {
            explorer_add_dotnet = function(picker)
              local dir = picker:dir()
              local easydotnet = require("easy-dotnet")

              easydotnet.create_new_item(dir, function(item_path)
                local tree = require("snacks.explorer.tree")
                local actions = require("snacks.explorer.actions")
                tree:open(dir)
                tree:refresh(dir)
                actions.update(picker, { target = item_path })
                picker:focus()
              end)
            end,
          },
        },
      },
    },
    terminal = {},
  },
}
