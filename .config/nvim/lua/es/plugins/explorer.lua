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
end

return M
