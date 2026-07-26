-- Zig task runner: compile-and-run with output, no session state.
-- Diagnostics are zls's job (build-on-save); this module only executes.
-- Shared process and output plumbing lives in es.runner.

local runner = require("es.runner")

local M = {}

-- A project is defined by build.zig, not by .git — a repository may contain
-- loose Zig files that are not part of any build graph.
local function project_root()
  return vim.fs.root(0, { "build.zig" })
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
    return runner.run({ "zig", "build", "run", "--color", "off" }, root)
  end

  local file = runner.current_file("Zig")
  if file then
    runner.run({ "zig", "run", file, "--color", "off" }, vim.fs.dirname(file))
  end
end

function M.test()
  local root = project_root()
  if root then
    -- `zig build test` is silent on success, which makes a pass
    -- indistinguishable from having run no tests at all.
    return runner.run({ "zig", "build", "test", "--color", "off", "--summary", "all" }, root)
  end

  local file = runner.current_file("Zig")
  if file then
    runner.run({ "zig", "test", file, "--color", "off" }, vim.fs.dirname(file))
  end
end

-- Always compiles the file standalone so --test-filter applies. A selected
-- test that transitively reaches build.zig.zon dependencies will not resolve
-- this way; use M.test() for those.
function M.test_nearest()
  local file = runner.current_file("Zig")
  if not file then
    return
  end

  local name = nearest_test()
  if not name then
    vim.notify("Zig: no named test above cursor, running file", vim.log.levels.INFO)
    return runner.run({ "zig", "test", file, "--color", "off" }, vim.fs.dirname(file))
  end

  runner.run({ "zig", "test", file, "--test-filter", name, "--color", "off" }, vim.fs.dirname(file))
end

function M.stop()
  runner.stop("Zig")
end

return M
