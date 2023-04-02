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
