local has_tree, tree = pcall(require, "nvim-tree")
if not has_tree then
  return
end

tree.setup {
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  }
}

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>", opt)
