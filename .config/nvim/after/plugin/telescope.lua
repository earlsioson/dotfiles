local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
if not has_telescope_builtin then
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

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fs", telescope_builtin.grep_string, {})
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
