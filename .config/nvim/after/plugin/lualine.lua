local has_lualine, lualine = pcall(require, "lualine")
if not has_lualine then
  return
end

lualine.setup {
  extensions = {
    "fugitive",
    "nvim-dap-ui",
    "quickfix",
  },
  tabline = {
    lualine_a = { 'buffers' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'tabs' }
  }
}
