local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
  return
end

cmp.setup.cmdline("@", {
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})
