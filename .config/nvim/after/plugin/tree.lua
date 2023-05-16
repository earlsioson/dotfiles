local has_tree, tree = pcall(require, "nvim-tree")
if not has_tree then
  return
end

local has_api, api = pcall(require, "nvim-tree.api")
if not has_api then
  return
end

tree.setup {
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  },
  renderer = {
    symlink_destination = false,
  }
}

local open_dir = function()
  vim.ui.input({
      prompt = "Open: ",
      default = "",
      completion = "dir",
    },
    function(input)
      api.tree.open({ path = input })
    end)
end

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>", opt)
vim.keymap.set("n", "<Leader>no", open_dir, opt)
vim.keymap.set("n", "<Leader>nc", "<Cmd>NvimTreeClose<CR>", opt)
