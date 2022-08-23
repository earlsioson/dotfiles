P = function(v)
  print(vim.inspect(v))
  return v
end

vim.keymap.set('n', '<leader><leader>x',
  function()
    vim.cmd([[w]])
    vim.cmd([[luafile %]])
  end,
  { noremap=true, silent=true }
)

vim.keymap.set('n', '<leader>G',
  function()
    vim.cmd([[G | only]])
  end,
  { noremap=true, silent=true }
)
-- hack for telescope find_files not honoring folds
-- https://github.com/tmhedberg/SimpylFold/issues/130
vim.api.nvim_create_autocmd('BufRead', {
   callback = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
         once = true,
         command = 'normal! zx'
      })
   end
})
