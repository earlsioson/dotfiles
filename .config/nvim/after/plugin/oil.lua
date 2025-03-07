local has_oil, oil = pcall(require, "oil")
if not has_oil then
  return
end

oil.setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
