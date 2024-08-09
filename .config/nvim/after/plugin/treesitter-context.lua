local has_treesitter_context, treesitter_context = pcall(require, "treesitter-context")
if not has_treesitter_context then
  return
end

treesitter_context.setup({
  enable = true,
  max_lines = 1,
})
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>x", treesitter_context.go_to_context, opt)
