local has_lualine, lualine = pcall(require, "lualine")
if not has_lualine then
  return
end

lualine.setup {
  options = {
    theme = "tokyonight"
  },
  tabline = {
    lualine_a = {
      {
        "buffers", icons_enabled = false
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  }
}
