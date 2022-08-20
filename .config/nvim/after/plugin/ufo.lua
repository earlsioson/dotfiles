local has_ufo, ufo = pcall(require, "ufo")
if not has_ufo then
  return
end

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

ufo.setup({
  provider_selector = function()
    return {'treesitter', 'indent'}
  end
})
