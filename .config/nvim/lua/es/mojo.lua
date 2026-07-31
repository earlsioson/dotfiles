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
--
-- Detection and invocation are deliberately separate: the venv binary is what
-- proves a toolchain exists, but `uv run` is what executes it. es.runner spawns
-- with Neovim's inherited environment, and mojo cannot locate the companion
-- binaries shipped beside it under site-packages -- crashpad_handler among them
-- -- when nothing in that environment points at the virtualenv. Running
-- .venv/bin/mojo by absolute path therefore succeeds or warns depending on
-- whether the shell that launched Neovim happened to be activated. `uv run`
-- supplies both VIRTUAL_ENV and a .venv/bin prefix on $PATH, which covers the
-- lookup either way, and --no-sync keeps a keypress off the lockfile.
--- @return string[]? argv prefix ending in the mojo command
--- @return string? root project root to run in, when there is one
local function mojo_command()
  local root = vim.fs.root(0, { "pixi.toml", "pyproject.toml", ".git" })

  if root and vim.fn.executable("pixi") == 1 and vim.fs.root(0, { "pixi.toml" }) then
    return { "pixi", "run", "mojo" }, root
  end

  if root and vim.fn.executable(vim.fs.joinpath(root, ".venv", "bin", "mojo")) == 1 then
    if vim.fn.executable("uv") == 1 then
      return { "uv", "run", "--no-sync", "mojo" }, root
    end
    return { vim.fs.joinpath(root, ".venv", "bin", "mojo") }, root
  end

  if vim.fn.executable("mojo") == 1 then
    return { "mojo" }
  end
end

--- @param verb string mojo subcommand to apply to the current file
local function launch(verb)
  local prefix, root = mojo_command()
  if not prefix then
    vim.notify(
      "Mojo: no toolchain found (uv add mojo --prerelease allow)",
      vim.log.levels.WARN
    )
    return
  end

  local file = runner.current_file("Mojo")
  if not file then
    return
  end

  -- A project runs from its root so `uv run` resolves the project it belongs
  -- to; a loose file falls back to its own directory, as Zig's runner does.
  runner.run(vim.list_extend(prefix, { verb, file }), root or vim.fs.dirname(file))
end

--- Build and execute the current file. Also the way tests are run.
function M.run()
  launch("run")
end

--- Compile the current file to an executable without running it.
function M.build()
  launch("build")
end

function M.stop()
  runner.stop("Mojo")
end

return M
