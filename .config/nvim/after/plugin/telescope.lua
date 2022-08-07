if not pcall(require, "telescope") then
  return
end

require("telescope").setup{
  defaults = {
    prompt_prefix = "🔍 ",
    file_ignore_patterns = { "node_modules" },
    layout_config = {
      width = 0.99 
    }
  }
}
require("telescope").load_extension("dap")
require("telescope").load_extension("file_browser")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", {})
vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>")
vim.keymap.set("n", "<leader>db", ":Telescope dap list_breakpoints<CR>")
