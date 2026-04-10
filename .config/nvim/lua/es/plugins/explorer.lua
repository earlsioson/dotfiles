local M = {}

function M.setup()
  require("nvim-tree").setup({
    view = {
      width = 50,
      relativenumber = true,
    },
  })

  require("oil").setup({
    columns = {
      "icon",
      { "permissions", highlight = "Comment" },
      "size",
      "mtime",
      "preview",
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = "fast_scratch",
    },
  })

  require("glow").setup({
    border = "rounded",
    width = 9999,
    height = 9999,
    width_ratio = 0.95,
    height_ratio = 0.9,
  })
end

return M
