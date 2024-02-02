vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>cp", "<Cmd>Copilot enable<CR>", opt)
vim.keymap.set("n", "<Leader>cP", "<Cmd>Copilot disable<CR>", opt)
