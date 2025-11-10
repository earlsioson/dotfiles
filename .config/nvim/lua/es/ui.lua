local opt = vim.opt

opt.laststatus = 3
opt.showmode = false
opt.fillchars:append({
  diff = " ",
  eob = " ",
})
