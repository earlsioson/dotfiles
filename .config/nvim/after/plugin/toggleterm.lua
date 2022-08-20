local has_toggleterm, toggleterm = pcall(require, "toggleterm")
if not has_toggleterm then
  return
end

toggleterm.setup()

vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", {noremap = true, silent = true})
