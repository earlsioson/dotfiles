local has_tree, tree = pcall(require, "nvim-tree")
if not has_tree then
  return
end

local has_api, api = pcall(require, "nvim-tree.api")
if not has_api then
  return
end

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del('n', '<C-k>', { buffer = bufnr })
  vim.keymap.set('n', '<M-i>', api.node.show_info_popup, opts('Info'))
end

tree.setup {
  on_attach = on_attach,
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  },
  renderer = {
    symlink_destination = false,
  },
  view = {
    relativenumber = true,
    width = 50,
  },
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
vim.keymap.set("n", "<Leader>nf", "<Cmd>NvimTreeFindFile<CR>", opt)
vim.keymap.set("n", "<Leader>no", open_dir, opt)
vim.keymap.set("n", "<Leader>nc", "<Cmd>NvimTreeClose<CR>", opt)
