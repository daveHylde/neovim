-- Workaround for a Herdr key-encoding bug that eats AltGr characters.
--
-- Neovim's TUI pushes kitty-keyboard flags 3 at startup (`CSI > 3 u` =
-- disambiguate + report-event-types; verified against nvim 0.12.4). At flags >= 3
-- Herdr 0.8.0 stops passing the host terminal's text through and resolves the
-- character itself from (keycode, modifiers) -- and that resolution honors Shift
-- but ignores ISO_Level3_Shift (AltGr), so it emits the base-layer key instead:
--
--   flags=1  AltGr+8 -> "["            correct
--   flags=3  AltGr+8 -> "8" + CSI 56;1:3u    base digit, level-3 dropped
--   flags=3  Shift+8 -> "(" + CSI 56;2:3u    Shift handled correctly
--
-- On a Norwegian layout every one of [ ] { } @ $ € lives on level 3, so all of
-- them break inside Herdr while the shell (which never enables CSI-u) is fine.
-- Ghostty at the same flags=3 sends the composed text, which is why this only
-- shows up under Herdr.
--
-- Popping Herdr back out of kitty mode restores the working text path. Nvim keeps
-- running happily on legacy encoding; the only thing given up is disambiguation of
-- pairs like <C-I>/<Tab> and <Esc>/<C-[>.
--
-- Remove this once Herdr resolves level-3 correctly at flags >= 3.

local M = {}

local POP = "\27[<u" -- CSI < u -- pop one kitty-keyboard flag entry

local function pop_kitty_keyboard()
  io.stdout:write(POP)
  io.stdout:flush()
end

function M.setup()
  if vim.env.HERDR_ENV ~= "1" then
    return
  end

  -- Nvim pushes its flags while the TUI starts up, so the pop has to land after
  -- that; a short defer is what makes it ordered rather than racing startup.
  local function schedule()
    vim.defer_fn(pop_kitty_keyboard, 150)
  end

  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    desc = "Herdr drops AltGr/level-3 chars at kitty flags>=3; revert to legacy key encoding",
    callback = schedule,
  })
end

return M
