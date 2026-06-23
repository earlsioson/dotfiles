-- Python host path - centralized for reuse across config
-- Try to locate the python executable inside the dotfiles virtualenv dynamically.
local function detect_python_path()
  local candidates = {
    -- Current resolved config path if symlinked
    vim.fn.resolve(vim.fn.stdpath("config")) .. "/../../.venv/bin/python",
    -- Common locations
    "~/dev/repos/dotfiles/.venv/bin/python",
    "~/src/dotfiles/.venv/bin/python",
    "~/dotfiles/.venv/bin/python",
  }
  for _, p in ipairs(candidates) do
    local path = vim.fn.expand(p)
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return vim.fn.expand("~/path/to/dotfiles/.venv/bin/python") -- placeholder fallback
end

vim.g.python_host_path = detect_python_path()

vim.g.copilot_no_tab_map = true

-- Lua compatibility: ensure unpack is available globally across all Lua versions
-- Lua 5.1/LuaJIT: unpack is global
-- Lua 5.2+: moved to table.unpack
_G.unpack = _G.unpack or table.unpack

-- tjdevries
P = function(v)
  print(vim.inspect(v))
  return v
end

vim.keymap.set('n', '<leader><leader>x',
  function()
    vim.cmd([[w]])
    vim.cmd([[luafile %]])
  end,
  { silent = true, desc = "Source current Lua file" }
)
