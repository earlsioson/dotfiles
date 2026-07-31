-- Python task runner: one-shot execution and test runner with output split.
-- Session state lives in Pyrepl (<Leader>p); one-shot execution lives here (<Leader>x).
-- Shared process and output plumbing lives in es.runner.

local runner = require("es.runner")

local M = {}

--- Find the project root directory (containing pyproject.toml, setup.py, .venv, etc.).
local function project_root()
  return vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".venv", ".git" })
end

--- Check if a file contains PEP 723 inline script metadata (`# /// script`).
local function has_script_metadata(file)
  if not file or file == "" then
    return false
  end

  local f = io.open(file, "r")
  if not f then
    return false
  end

  for _ = 1, 20 do
    local line = f:read("*l")
    if not line then
      break
    end
    if line:find("^#%s*///%s*script") then
      f:close()
      return true
    end
  end

  f:close()
  return false
end

--- Resolve python executable command.
--- Prefers `uv run` if uv is present (with script metadata, uv project root, or system uv),
--- then project virtualenv (`.venv/bin/python`), then `python3` or `python` from $PATH.
local function resolve_python(dir, file)
  local is_uv = vim.fn.executable("uv") == 1

  if is_uv then
    if has_script_metadata(file) or (dir and vim.fs.root(0, { "pyproject.toml", "uv.lock" })) then
      return { "uv", "run" }
    end
  end

  if dir then
    local venv_python = dir .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return { venv_python }
    end
  end

  if is_uv then
    return { "uv", "run" }
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

--- Parse pyproject.toml in dir to find project name and script entrypoints.
--- @param dir string|nil
--- @return string|nil project_name
--- @return table<string, string> scripts table of script_name -> target
local function parse_pyproject(dir)
  if not dir then
    return nil, {}
  end

  local path = dir .. "/pyproject.toml"
  local f = io.open(path, "r")
  if not f then
    return nil, {}
  end

  local content = f:read("*a")
  f:close()

  if not content then
    return nil, {}
  end

  local project_name = content:match('%[project%]%s*.-name%s*=%s*["\']([^"\']+)["\']')
  local scripts = {}

  local scripts_sec = content:match("%[project%.scripts%]\n(.*)")
  if scripts_sec then
    for line in scripts_sec:gmatch("[^\r\n]+") do
      if line:match("^%s*%[") then
        break
      end
      local name, target = line:match('^%s*([%w_%-]+)%s*=%s*["\']([^"\']+)["\']')
      if name and target then
        scripts[name] = target
      end
    end
  end

  return project_name, scripts
end

function M.run()
  local file = runner.current_file("Python")
  if not file then
    return
  end

  local root = project_root() or vim.fs.dirname(file)
  local is_uv = vim.fn.executable("uv") == 1
  local project_name, scripts = parse_pyproject(root)

  if is_uv and root then
    local filename = vim.fs.basename(file)
    local rel_path = file:sub(#root + 2)

    -- 1. If project.scripts has an entry matching project_name:
    if project_name and scripts[project_name] then
      if filename == "__init__.py" or filename == "main.py" or rel_path:find(project_name, 1, true) then
        runner.run({ "uv", "run", project_name }, root)
        return
      end
    end

    -- 2. Check if any script in project.scripts matches the file or module
    for script_name, target in pairs(scripts) do
      local mod_path = target:match("^([^:]+)")
      if mod_path then
        local mod_file_part = mod_path:gsub("%.", "/")
        if rel_path:find(mod_file_part, 1, true) then
          runner.run({ "uv", "run", script_name }, root)
          return
        end
      end
    end
  end

  -- 3. If file is __init__.py defining main() without top-level main() call
  if file:sub(-11) == "/__init__.py" then
    local f = io.open(file, "r")
    if f then
      local code = f:read("*a")
      f:close()
      if code and code:find("def main%(") and not code:find('if __name__ == ["\']__main__["\']') then
        local parent_dir = vim.fs.dirname(file)
        local pkg_name = vim.fs.basename(parent_dir)
        if pkg_name and pkg_name ~= "" and pkg_name ~= "src" then
          local cmd = is_uv and { "uv", "run", "python" } or { "python3" }
          table.insert(cmd, "-c")
          table.insert(cmd, string.format("import %s; getattr(%s, 'main', lambda: None)()", pkg_name, pkg_name))
          runner.run(cmd, root)
          return
        end
      end
    end
  end

  local cmd = resolve_python(root, file)
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
