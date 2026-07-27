-- Rust task runner. Shared process and output plumbing lives in es.runner.
--
-- Cargo is the unit of work: it resolves the workspace itself, so unlike Zig
-- there is no project-versus-file split to manage. The nearest Cargo.toml is
-- the crate — in a workspace that is the member, which is what `cargo run`
-- expects. There is deliberately no loose-file fallback: rustc compiles and
-- runs as two separate steps, and runner.run takes a single argv.

local runner = require("es.runner")

local M = {}

--- Crate directory for the current buffer, or nil with a notification.
local function crate_dir()
  if vim.fn.executable("cargo") ~= 1 then
    vim.notify("Rust: cargo not found (rustup install stable)", vim.log.levels.WARN)
    return nil
  end

  local root = vim.fs.root(0, { "Cargo.toml" })
  if not root then
    vim.notify("Rust: no Cargo.toml above this file", vim.log.levels.WARN)
    return nil
  end
  return root
end

-- Cargo colours by default when stdout is a tty. It isn't one here, so this is
-- belt-and-braces — but an inherited CLICOLOR_FORCE would otherwise dump escape
-- sequences into a buffer that renders them literally.
local function cargo(subcommand, ...)
  return { "cargo", subcommand, "--color", "never", ... }
end

-- Find the enclosing fn, then confirm the attribute run above it carries a test
-- marker. Rust stacks attributes (`#[test]` over `#[ignore]`) and allows doc
-- comments between them, so the whole contiguous run is walked rather than just
-- the preceding line as in Odin. Matching `test` loosely also catches
-- `#[tokio::test]` and `#[rstest]`.
local function nearest_test()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

  for i = #lines, 1, -1 do
    -- Test fns live inside `mod tests`, so they are indented, and may be async.
    local name = lines[i]:match("^%s*fn%s+([%w_]+)") or lines[i]:match("^%s*async%s+fn%s+([%w_]+)")
    if name then
      for j = i - 1, 1, -1 do
        local line = vim.trim(lines[j])
        if line:match("^#%[.*test") then
          return name
        end
        if not (line:match("^#%[") or line:match("^//")) then
          return nil
        end
      end
      return nil
    end
  end
end

function M.run()
  local dir = crate_dir()
  if dir then
    runner.run(cargo("run"), dir)
  end
end

function M.build()
  local dir = crate_dir()
  if dir then
    runner.run(cargo("build"), dir)
  end
end

function M.test()
  local dir = crate_dir()
  if dir then
    runner.run(cargo("test"), dir)
  end
end

-- The bare name is a substring filter, so `parse` also runs `parse_empty`.
-- Narrowing that would mean passing `-- --exact` with a fully qualified path
-- (`config::tests::parse`), which means reconstructing `mod` nesting from the
-- buffer. Zig's --test-filter behaves the same way, so this matches.
function M.test_nearest()
  local dir = crate_dir()
  if not dir then
    return
  end

  local name = nearest_test()
  if not name then
    vim.notify("Rust: no #[test] above cursor, running crate", vim.log.levels.INFO)
    return runner.run(cargo("test"), dir)
  end

  runner.run(cargo("test", name), dir)
end

function M.stop()
  runner.stop("Rust")
end

return M
