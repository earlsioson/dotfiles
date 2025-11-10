if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("es.globals")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = vim.g.python_host_path

do
  local shared = vim.fn.expand("~/.vim/common.vim")
  if vim.fn.filereadable(shared) == 1 then
    vim.cmd.source(shared)
  end
end

require("es.options")
require("es.keymaps")
require("es.autocmds")
require("es.ui")
require("es.lazy")
