-- Zero config lean idiomatic Augment setup
return {
  "augmentcode/augment.vim",
  cmd = "Augment",
  init = function()
    -- Only essential configuration - dynamic workspace detection
    vim.g.augment_workspace_folders = {
      vim.fn.getcwd(), -- Current working directory
    }
  end,
}
