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
        files = {
          hidden = true,
          ignored = true,
          exclude = { "**/roslyn-source-generated:**" },
        },
        grep = {
          hidden = true,
          ignored = true,
          exclude = { "**/roslyn-source-generated:**" },
        },
      },
      filter = {
        ---@param item snacks.picker.Item
        filter = function(item)
          if item.file then
            if item.file:match("^roslyn%-source%-generated:") or item.file:match("/roslyn%-source%-generated:") then
              return false
            end
          end
          return true
        end,
      },
    },
    terminal = {},
  },
}
