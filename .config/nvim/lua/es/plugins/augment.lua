return {
  "augmentcode/augment.vim",
  event = "InsertEnter",
  cmd = "Augment",
  init = function()
    vim.g.augment_workspace_folders = {
      '/Users/earl/dev/rolflaw/repos/silvertek',
      '/Users/earl/dev/repos/portfolio'
    }
  end,
}
