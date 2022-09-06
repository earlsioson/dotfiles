local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
if not has_telescope_builtin then
  return
end

local has_frecency, _ = pcall(telescope.load_extension, "frecency")
if not has_frecency then
  return
end

local has_file_browser, _ = pcall(telescope.load_extension, "file_browser")
if not has_file_browser then
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

local has_fzf, _ = pcall(telescope.load_extension, "fzf")
if not has_fzf then
  return
end

local opt = {noremap = true, silent = true}
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opt)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", opt)
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", opt)
vim.keymap.set("n", "<leader>fG", "<cmd>Telescope live_grep<cr>", opt)

vim.keymap.set("n", "<leader>fr", telescope.extensions.frecency.frecency, opt)
vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, opt)
