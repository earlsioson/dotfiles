-- Python task runner: one-shot execution and test runner with output split.
-- Session state lives in Pyrepl (<Leader>p); one-shot execution lives here (<Leader>x).
-- Shared process and output plumbing lives in es.runner.

local runner = require("es.runner")

local M = {}

--- Find the project root directory (containing pyproject.toml, setup.py, .venv, etc.).
local function project_root()
  return vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".venv", ".git" })
end

--- Resolve python executable command.
--- Prefers project virtualenv (`.venv/bin/python`), then `uv run python` if uv is present with a project root,
--- then `python3` or `python` from $PATH.
local function resolve_python(dir)
  if dir then
    local venv_python = dir .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return { venv_python }
    end
  end

  if vim.fn.executable("uv") == 1 and vim.fs.root(0, { "pyproject.toml", "uv.lock" }) then
    return { "uv", "run", "python" }
  end

  if vim.fn.executable("python3") == 1 then
    return { "python3" }
  elseif vim.fn.executable("python") == 1 then
    return { "python" }
  end

  return nil
end

--- Resolve pytest executable command.
--- Prefers project virtualenv (`.venv/bin/pytest` or `.venv/bin/python -m pytest`),
--- then `uv run pytest` if uv is present, then `pytest` or `python3 -m pytest`.
local function resolve_pytest(dir)
  if dir then
    local venv_pytest = dir .. "/.venv/bin/pytest"
    if vim.fn.executable(venv_pytest) == 1 then
      return { venv_pytest }
    end
    local venv_python = dir .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return { venv_python, "-m", "pytest" }
    end
  end

  if vim.fn.executable("uv") == 1 and vim.fs.root(0, { "pyproject.toml", "uv.lock" }) then
    return { "uv", "run", "pytest" }
  end

  if vim.fn.executable("pytest") == 1 then
    return { "pytest" }
  elseif vim.fn.executable("python3") == 1 then
    return { "python3", "-m", "pytest" }
  elseif vim.fn.executable("python") == 1 then
    return { "python", "-m", "pytest" }
  end

  return nil
end

--- Find the nearest test function or class above the cursor.
local function nearest_test()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

  for i = #lines, 1, -1 do
    local fn_name = lines[i]:match("^%s*def%s+(test_[%w_]+)") or lines[i]:match("^%s*async%s+def%s+(test_[%w_]+)")
    if fn_name then
      return fn_name
    end
    local cls_name = lines[i]:match("^%s*class%s+(Test[%w_]+)")
    if cls_name then
      return cls_name
    end
  end
  return nil
end

function M.run()
  local file = runner.current_file("Python")
  if not file then
    return
  end

  local root = project_root() or vim.fs.dirname(file)
  local cmd = resolve_python(root)
  if not cmd then
    vim.notify("Python: no python executable found", vim.log.levels.WARN)
    return
  end

  local argv = vim.list_extend({}, cmd)
  table.insert(argv, file)
  runner.run(argv, root)
end

function M.test()
  local file = runner.current_file("Python")
  local root = project_root() or (file and vim.fs.dirname(file)) or vim.fn.getcwd()
  local cmd = resolve_pytest(root)
  if not cmd then
    vim.notify("Python: no pytest runner found", vim.log.levels.WARN)
    return
  end

  local argv = vim.list_extend({}, cmd)
  runner.run(argv, root)
end

function M.test_nearest()
  local file = runner.current_file("Python")
  if not file then
    return
  end

  local root = project_root() or vim.fs.dirname(file)
  local cmd = resolve_pytest(root)
  if not cmd then
    vim.notify("Python: no pytest runner found", vim.log.levels.WARN)
    return
  end

  local name = nearest_test()
  local argv = vim.list_extend({}, cmd)
  table.insert(argv, file)
  if name then
    table.insert(argv, "-k")
    table.insert(argv, name)
  else
    vim.notify("Python: no test function/class above cursor, running file", vim.log.levels.INFO)
  end

  runner.run(argv, root)
end

function M.stop()
  runner.stop("Python")
end

return M
