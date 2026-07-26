-- Zig task runner: compile-and-run with output, no session state.
-- Diagnostics are zls's job (build-on-save); this module only executes.

local M = {}

local state = {
  buf = nil,
  job = nil,
  pending = "",
  -- Bumped whenever a run is superseded or stopped, so a late exit callback
  -- from an abandoned job can identify itself as stale and stay quiet.
  seq = 0,
}

-- A project is defined by build.zig, not by .git — a repository may contain
-- loose Zig files that are not part of any build graph.
local function project_root()
  return vim.fs.root(0, { "build.zig" })
end

local function output_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "zigrun"
  vim.api.nvim_buf_set_name(buf, "zig://output")

  state.buf = buf
  return buf
end

local function open_window(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end

  local current = vim.api.nvim_get_current_win()
  vim.cmd("botright 12split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
  vim.api.nvim_set_current_win(current)
  return win
end

local function append(lines)
  local flat = {}
  for _, line in ipairs(lines) do
    vim.list_extend(flat, vim.split(line, "\n", { plain = true }))
  end

  local buf = output_buf()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, flat)
  vim.bo[buf].modifiable = false

  local win = open_window(buf)
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

local function reset(header)
  local buf = output_buf()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { header, "" })
  vim.bo[buf].modifiable = false
  open_window(buf)
end

-- vim.system delivers arbitrary chunks, not whole lines; hold the tail back
-- until a newline arrives so output is not split mid-line.
local function on_data(_, chunk)
  if not chunk then
    return
  end

  state.pending = state.pending .. chunk
  local lines = {}
  while true do
    local newline = state.pending:find("\n")
    if not newline then
      break
    end
    -- gsub returns a count as its second value; bind it off so table.insert
    -- does not read that count as a position argument.
    local line = state.pending:sub(1, newline - 1):gsub("\r$", "")
    table.insert(lines, line)
    state.pending = state.pending:sub(newline + 1)
  end

  if #lines > 0 then
    vim.schedule(function()
      append(lines)
    end)
  end
end

local function terminate(job)
  -- Negative pid signals the whole process group; fall back to the single
  -- process if the platform rejects that.
  if not pcall(vim.uv.kill, -job.pid, "sigterm") then
    pcall(function()
      job:kill("sigterm")
    end)
  end
end

local function run(cmd, cwd)
  if state.job then
    terminate(state.job)
    state.job = nil
  end
  state.pending = ""
  state.seq = state.seq + 1
  local seq = state.seq

  -- Quote arguments containing spaces so the echoed command stays readable;
  -- test names in particular are frequently multi-word.
  local shown = {}
  for _, arg in ipairs(cmd) do
    table.insert(shown, arg:find("%s") and ('"' .. arg .. '"') or arg)
  end
  reset("$ " .. table.concat(shown, " "))

  -- detach puts the child in its own process group. `zig build run` spawns the
  -- compiled program as a grandchild, and signalling only the build runner
  -- leaves that grandchild alive holding the output pipes open, so the exit
  -- callback never fires. Owning the group lets stop() signal the whole tree.
  state.job = vim.system(cmd, {
    cwd = cwd,
    detach = true,
    stdout = on_data,
    stderr = on_data,
  }, function(result)
    vim.schedule(function()
      if seq ~= state.seq then
        return
      end
      if state.pending ~= "" then
        append({ state.pending })
        state.pending = ""
      end
      append({ "", ("[exit %d]"):format(result.code) })
      state.job = nil
    end)
  end)
end

local function current_file()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.notify("Zig: buffer has no file", vim.log.levels.WARN)
    return nil
  end
  return name
end

-- Scan upward for the enclosing `test "name"` block. A line scan is used
-- instead of treesitter so this works before the parser is installed, and
-- because container-level test declarations are unindented by convention.
local function nearest_test()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

  for i = #lines, 1, -1 do
    local name = lines[i]:match('^test%s+"(.-)"')
    if name then
      return name
    end
    if lines[i]:match("^test%s*{") then
      return nil -- unnamed test; not filterable
    end
  end
end

function M.run()
  local root = project_root()
  if root then
    return run({ "zig", "build", "run", "--color", "off" }, root)
  end

  local file = current_file()
  if file then
    run({ "zig", "run", file, "--color", "off" }, vim.fs.dirname(file))
  end
end

function M.test()
  local root = project_root()
  if root then
    -- `zig build test` is silent on success, which makes a pass
    -- indistinguishable from having run no tests at all.
    return run({ "zig", "build", "test", "--color", "off", "--summary", "all" }, root)
  end

  local file = current_file()
  if file then
    run({ "zig", "test", file, "--color", "off" }, vim.fs.dirname(file))
  end
end

-- Always compiles the file standalone so --test-filter applies. Files that
-- import build.zig.zon dependencies will not resolve here; use M.test().
function M.test_nearest()
  local file = current_file()
  if not file then
    return
  end

  local name = nearest_test()
  if not name then
    vim.notify("Zig: no named test above cursor, running file", vim.log.levels.INFO)
    return run({ "zig", "test", file, "--color", "off" }, vim.fs.dirname(file))
  end

  run({ "zig", "test", file, "--test-filter", name, "--color", "off" }, vim.fs.dirname(file))
end

function M.stop()
  if not state.job then
    vim.notify("Zig: nothing running", vim.log.levels.INFO)
    return
  end

  state.seq = state.seq + 1

  terminate(state.job)
  state.job = nil
  -- Report here rather than waiting on the exit callback, which may be
  -- delayed until every inherited pipe is closed.
  append({ "", "[stopped]" })
end

-- A detached child outlives Neovim, so make sure quitting takes it down.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("es_zig_cleanup", { clear = true }),
  callback = function()
    if state.job then
      terminate(state.job)
      state.job = nil
    end
  end,
})

return M
