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

telescope.setup {
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

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files hidden=true<CR>", opt)
vim.keymap.set("n", "<Leader>fF", "<Cmd>Telescope find_files<CR>", opt)
vim.keymap.set("n", "<Leader>fG", "<Cmd>Telescope git_files<CR>", opt)
vim.keymap.set("n", "<Leader>fs", "<Cmd>Telescope grep_string<CR>", opt)
vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope live_grep<CR>", opt)
vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", opt)
vim.keymap.set("n", "<Leader><Leader>fb", "<Cmd>Telescope buffers<CR>", opt)

vim.keymap.set("n", "<Leader>fr", telescope.extensions.frecency.frecency, opt)
vim.keymap.set("n", "<Leader>fB", telescope.extensions.file_browser.file_browser, opt)
vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope file_browser respect_gitignore=false<CR>", opt)
