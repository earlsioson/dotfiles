local has_neoscroll, neoscroll = pcall(require, "neoscroll")
if not has_neoscroll then
  return
end

neoscroll.setup({
  duration_multiplier = 2.0,
})
