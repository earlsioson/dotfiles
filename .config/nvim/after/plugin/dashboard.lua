local has_dashboard, dashboard = pcall(require, "dashboard")
if not has_dashboard then
  return
end

dashboard.setup({
  theme = 'hyper',
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Search',
        group = 'Label',
        action = 'Telescope live_grep_args',
        key = 's',
      },
      {
        icon = '󰀶 ',
        icon_hl = '@variable',
        desc = 'Browse',
        group = 'Label',
        action = 'Telescope file_browser',
        key = 'b',
      },
    },
    project = {
      enable = false,
    },
  },
})
