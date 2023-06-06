local has_harpoon_mark, harpoon_mark = pcall(require, "harpoon.mark")
if not has_harpoon_mark then
  return
end

local has_harpoon_ui, harpoon_ui = pcall(require, "harpoon.ui")
if not has_harpoon_ui then
  return
end

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>ha", harpoon_mark.add_file, opt)
vim.keymap.set("n", "<Leader>hq", harpoon_ui.toggle_quick_menu, opt)
vim.keymap.set("n", "[h", harpoon_ui.nav_prev, opt)
vim.keymap.set("n", "]h", harpoon_ui.nav_next, opt)
