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
    picker = {},
    terminal = {},
  },
}
