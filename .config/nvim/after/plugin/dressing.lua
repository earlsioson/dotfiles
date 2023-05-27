local has_dressing, dressing = pcall(require, "dressing")
if not has_dressing then
  return
end
dressing.setup({
  input = {
    relative = "editor",
    min_width = .9,
    win_options = {
      winblend = 0,
    }
  },
})
