-- Mojo task runner. Shared process and output plumbing lives in es.runner.
--
-- Mojo has no build-system driver to target: `mojo run` takes a file, so there
-- is no project/file split like Zig's. `mojo test` was removed in October 2025
-- in favour of self-contained test executables, so running a program and
-- running tests are the same command against different files:
--
--   from std.testing import assert_equal, TestSuite
--
--   def test_example() raises:
--       assert_equal(inc(1), 2)
--
--   def main() raises:
--       TestSuite.discover_tests[__functions_in_module()]().run()
--
-- Mojo runs only on Apple silicon macOS and Ubuntu, so every entry point
-- degrades to a notification rather than an error on unsupported hosts.

local runner = require("es.runner")

local M = {}

-- uv installs the toolchain into the project virtualenv rather than onto
-- $PATH, so look there first. Mirrors project_python() in es.lsp.pyright.
local function mojo_path()
  local root = vim.fs.root(0, { "pyproject.toml", ".git" })
  if root then
    local candidate = vim.fs.joinpath(root, ".venv", "bin", "mojo")
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  if vim.fn.executable("mojo") == 1 then
    return "mojo"
  end
end

local function resolve()
  local mojo = mojo_path()
  if not mojo then
    vim.notify(
      "Mojo: no toolchain found (uv add mojo --prerelease allow)",
      vim.log.levels.WARN
    )
    return nil
  end

  local file = runner.current_file("Mojo")
  if not file then
    return nil
  end

  return mojo, file
end

--- Build and execute the current file. Also the way tests are run.
function M.run()
  local mojo, file = resolve()
  if mojo then
    runner.run({ mojo, "run", file }, vim.fs.dirname(file))
  end
end

--- Compile the current file to an executable without running it.
function M.build()
  local mojo, file = resolve()
  if mojo then
    runner.run({ mojo, "build", file }, vim.fs.dirname(file))
  end
end

function M.stop()
  runner.stop("Mojo")
end

return M
