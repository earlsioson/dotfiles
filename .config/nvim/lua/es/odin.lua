-- Odin task runner. Shared process and output plumbing lives in es.runner.
--
-- Odin's compilation unit is a directory: every .odin file in a folder forms
-- one package, and `odin run .` builds all of them together. There is no
-- project-versus-file split like Zig's, and no build manifest to look for —
-- the enclosing directory is the unit of work.

local runner = require("es.runner")

local M = {}

--- Directory holding the current buffer, which is the Odin package.
local function package_dir()
  local file = runner.current_file("Odin")
  if not file then
    return nil
  end
  return vim.fs.dirname(file)
end

--- Package name as declared in the file, which need not match the directory.
--- ODIN_TEST_NAMES is qualified by this, not by the folder.
local function package_name()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 50, false)) do
    local name = line:match("^package%s+([%w_]+)")
    if name then
      return name
    end
  end
end

-- Find the enclosing procedure, then confirm the line above it carries a test
-- attribute. Odin puts `@(test)` on its own line before the declaration, so
-- this is a two-step scan rather than Zig's single-line match.
local function nearest_test()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

  for i = #lines, 1, -1 do
    local name = lines[i]:match("^([%w_]+)%s*::%s*proc")
    if name then
      for j = i - 1, 1, -1 do
        local prev = vim.trim(lines[j])
        if prev ~= "" then
          -- Attributes may be grouped, e.g. `@(test, private)`.
          if prev:match("^@%(.*test.*%)") then
            return name
          end
          return nil
        end
      end
      return nil
    end
  end
end

function M.run()
  local dir = package_dir()
  if dir then
    runner.run({ "odin", "run", "." }, dir)
  end
end

function M.build()
  local dir = package_dir()
  if dir then
    runner.run({ "odin", "build", "." }, dir)
  end
end

function M.test()
  local dir = package_dir()
  if dir then
    runner.run({ "odin", "test", "." }, dir)
  end
end

function M.test_nearest()
  local dir = package_dir()
  if not dir then
    return
  end

  local test = nearest_test()
  local package = package_name()
  if not test or not package then
    vim.notify("Odin: no @(test) above cursor, running package", vim.log.levels.INFO)
    return runner.run({ "odin", "test", "." }, dir)
  end

  runner.run({
    "odin",
    "test",
    ".",
    "-define:ODIN_TEST_NAMES=" .. package .. "." .. test,
  }, dir)
end

function M.stop()
  runner.stop("Odin")
end

return M
