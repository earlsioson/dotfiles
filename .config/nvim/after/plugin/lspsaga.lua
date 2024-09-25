local has_lspsaga, lspsaga = pcall(require, "lspsaga")
if not has_lspsaga then
  return
end

vim.keymap.set({ "n", "t" }, "<Leader>sT", "<Cmd>Lspsaga term_toggle<CR>")

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>so", "<cmd>Lspsaga outline<cr>", opt)
vim.keymap.set("n", "<leader>sh", "<cmd>Lspsaga hover_doc<cr>", opt)
vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga incoming_calls<cr>", opt)
vim.keymap.set("n", "<leader>sC", "<cmd>Lspsaga outgoing_calls<cr>", opt)
vim.keymap.set("n", "<leader>sa", "<cmd>Lspsaga code_action<cr>", opt)
vim.keymap.set("n", "<leader>sp", "<cmd>Lspsaga peek_definition<cr>", opt)
vim.keymap.set("n", "<leader>sP", "<cmd>Lspsaga peek_type_definition<cr>", opt)
vim.keymap.set("n", "<leader>sd", "<cmd>Lspsaga goto_definition<cr>", opt)
vim.keymap.set("n", "<leader>st", "<cmd>Lspsaga goto_type_definition<cr>", opt)
vim.keymap.set("n", "<leader>sf", "<cmd>Lspsaga finder<cr>", opt)
vim.keymap.set("n", "<leader>sr", "<cmd>Lspsaga rename<cr>", opt)
vim.keymap.set("n", "<leader>sn", "<cmd>Lspsaga diagnostic_jump_next<cr>", opt)
vim.keymap.set("n", "<leader>sp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opt)

lspsaga.setup {}
