if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("es.globals")
require("es.options")
require("es.keymaps")
require("es.autocmds")
require("es.ui")
require("es.lazy")
