-- Python host path - centralized for reuse across config
vim.g.python_host_path = vim.fn.expand("~/dev/repos/dotfiles/.venv/bin/python")

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
  { noremap = true, silent = true }
)
