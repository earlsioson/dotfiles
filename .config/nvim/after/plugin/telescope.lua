local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

telescope.setup{
  defaults = {
    prompt_prefix = "🔍 ",
    file_ignore_patterns = { "node_modules" },
    layout_config = {
      width = 0.99 
    }
  }
}

telescope.load_extension("dap")
telescope.load_extension("file_browser")

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", {})
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", {})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {})
vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>")
vim.keymap.set("n", "<leader>db", ":Telescope dap list_breakpoints<CR>")
