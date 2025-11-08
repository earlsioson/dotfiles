local has_glow, glow = pcall(require, "glow")
if not has_glow then
  return
end

glow.setup({
  border = "rounded",
})

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>mp", "<cmd>Glow<cr>", opt)
