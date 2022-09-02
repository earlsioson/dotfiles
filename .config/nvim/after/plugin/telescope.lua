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
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, opt)
vim.keymap.set("n", "<leader>fs", telescope_builtin.grep_string, opt)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, opt)

vim.keymap.set("n", "<leader>fh", telescope.extensions.frecency.frecency, opt)
vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, opt)
