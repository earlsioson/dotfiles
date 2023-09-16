local has_lualine, lualine = pcall(require, "lualine")
if not has_lualine then
  return
end

local has_as_lib, as_lib = pcall(require, "auto-session.lib")
if not has_as_lib then
  return
end

lualine.setup {
  options = {
    theme = "tokyonight"
  },
  extensions = {
    "fugitive",
    "nvim-dap-ui",
    "quickfix",
  },
  sections = {
    lualine_b = { "FugitiveHead" },
    lualine_c = { as_lib.current_session_name, 'filename' },
  }
  -- tabline = {
  --   lualine_a = { 'buffers' },
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = { 'tabs' }
  -- }
}
