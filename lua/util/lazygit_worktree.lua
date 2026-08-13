-- Make Neovim follow lazygit when it switches worktree (or repo).
--
-- lazygit changes the working directory of *its own process* when you switch
-- worktree, so nothing is communicated back to Neovim. While a lazygit
-- terminal is open we poll `/proc/<pid>/cwd` (cheap: a single readlink), and
-- when it moves we `:cd` there and re-point every open buffer at the same
-- relative path in the new worktree.
--
-- Linux only (needs /proc). Fires `User LazygitWorktreeChanged` on success.

local M = {}

local uv = vim.uv or vim.loop
local POLL_MS = 400

---@param pid integer
---@return string?
local function proc_comm(pid)
  local fd = io.open("/proc/" .. pid .. "/comm", "r")
  if not fd then
    return nil
  end
  local name = fd:read("l")
  fd:close()
  return name
end

---@param pid integer
---@return string?
local function proc_cwd(pid)
  local target = uv.fs_readlink("/proc/" .. pid .. "/cwd")
  return target and vim.fs.normalize(target) or nil
end

---@param pid integer
---@return integer[]
local function proc_children(pid)
  local fd = io.open(("/proc/%d/task/%d/children"):format(pid, pid), "r")
  if not fd then
    return {}
  end
  local line = fd:read("l") or ""
  fd:close()
  local children = {}
  for child in line:gmatch("%d+") do
    table.insert(children, tonumber(child))
  end
  return children
end

-- The terminal job is usually lazygit itself, but tolerate a shell wrapper.
---@param pid integer
---@param depth? integer
---@return integer?
local function find_lazygit(pid, depth)
  depth = depth or 2
  if proc_comm(pid) == "lazygit" then
    return pid
  end
  if depth <= 0 then
    return nil
  end
  for _, child in ipairs(proc_children(pid)) do
    local found = find_lazygit(child, depth - 1)
    if found then
      return found
    end
  end
  return nil
end

---@param dir string
---@return boolean
local function is_git_root(dir)
  local git = dir .. "/.git"
  -- a linked worktree has a `.git` file, the main worktree a directory
  return vim.fn.isdirectory(git) == 1 or vim.fn.filereadable(git) == 1
end

--- Re-point a buffer's window(s) at `path`, keeping the cursor position.
---@param buf integer
---@param path string
local function replace_buf(buf, path)
  local newbuf = vim.fn.bufadd(path)
  vim.fn.bufload(newbuf)
  vim.bo[newbuf].buflisted = true

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      local cursor = vim.api.nvim_win_get_cursor(win)
      vim.api.nvim_win_set_buf(win, newbuf)
      local lines = vim.api.nvim_buf_line_count(newbuf)
      pcall(vim.api.nvim_win_set_cursor, win, { math.min(cursor[1], lines), cursor[2] })
    end
  end

  pcall(vim.api.nvim_buf_delete, buf, {})
end

--- Move Neovim (cwd + buffers) to `new_root`.
---@param new_root string
---@return boolean moved
function M.follow(new_root)
  new_root = vim.fs.normalize(new_root)
  local old_root = vim.fs.normalize(uv.cwd() or "")

  if new_root == old_root or vim.fn.isdirectory(new_root) == 0 or not is_git_root(new_root) then
    return false
  end

  local prefix = old_root .. "/"
  local moves, dirty, missing = {}, 0, 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and name ~= "" then
      name = vim.fs.normalize(name)
      if vim.startswith(name, prefix) then
        local target = new_root .. "/" .. name:sub(#prefix + 1)
        if vim.bo[buf].modified then
          dirty = dirty + 1
        elseif vim.fn.filereadable(target) == 1 then
          moves[buf] = target
        else
          missing = missing + 1
        end
      end
    end
  end

  vim.cmd.cd(vim.fn.fnameescape(new_root))
  for buf, target in pairs(moves) do
    replace_buf(buf, target)
  end
  vim.cmd.checktime()

  local msg = { ("Followed lazygit to `%s`"):format(vim.fn.fnamemodify(new_root, ":~")) }
  table.insert(msg, ("- %d buffer(s) moved"):format(vim.tbl_count(moves)))
  if dirty > 0 then
    table.insert(msg, ("- %d modified buffer(s) left alone"):format(dirty))
  end
  if missing > 0 then
    table.insert(msg, ("- %d buffer(s) not present in the new worktree"):format(missing))
  end
  vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, { title = "lazygit worktree" })

  vim.api.nvim_exec_autocmds("User", {
    pattern = "LazygitWorktreeChanged",
    data = { old = old_root, new = new_root },
  })
  return true
end

--- Poll a running lazygit process for cwd changes.
---@param buf integer terminal buffer, watched so we stop when it goes away
---@param pid integer
local function watch(buf, pid)
  local last = proc_cwd(pid)
  if not last then
    return
  end

  local timer = assert(uv.new_timer())
  timer:start(
    POLL_MS,
    POLL_MS,
    vim.schedule_wrap(function()
      local cwd = proc_cwd(pid)
      if not cwd or not vim.api.nvim_buf_is_valid(buf) then
        if not timer:is_closing() then
          timer:stop()
          timer:close()
        end
        return
      end
      if cwd ~= last then
        last = cwd
        M.follow(cwd)
      end
    end)
  )
end

function M.setup()
  if not uv.fs_stat("/proc/self/cwd") then
    return -- /proc required
  end

  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("lazygit_worktree", { clear = true }),
    callback = function(ev)
      local chan = vim.b[ev.buf].terminal_job_id
      local ok, job_pid = pcall(vim.fn.jobpid, chan)
      if not ok then
        return
      end
      -- lazygit may not have exec'd yet when TermOpen fires
      vim.defer_fn(function()
        local pid = find_lazygit(job_pid)
        if pid and vim.api.nvim_buf_is_valid(ev.buf) then
          watch(ev.buf, pid)
        end
      end, 300)
    end,
  })
end

return M
