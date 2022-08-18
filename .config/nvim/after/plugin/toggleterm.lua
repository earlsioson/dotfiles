if not pcall(require, "toggleterm") then
  return
end

require("toggleterm").setup()

local Terminal  = require('toggleterm.terminal').Terminal

vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", {noremap = true, silent = true})
