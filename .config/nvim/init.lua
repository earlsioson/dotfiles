if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = vim.fn.expand("~/dev/repos/dotfiles/.venv/bin/python")

do
  local shared = vim.fn.expand("~/.vim/common.vim")
  if vim.fn.filereadable(shared) == 1 then
    vim.cmd.source(shared)
  end
end

require("es.globals")
require("es.options")
require("es.keymaps")
require("es.autocmds")
require("es.ui")
require("es.lazy")
