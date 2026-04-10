local M = {}

function M.setup()
  require("tokyonight").setup({
    style = "night",
  })
  vim.cmd.colorscheme("tokyonight-night")

  require("mini.icons").setup({})
  require("mini.icons").mock_nvim_web_devicons()

  require("dressing").setup({
    input = {
      relative = "editor",
      min_width = 0.9,
      win_options = {
        winblend = 0,
      },
    },
    select = {
      backend = { "builtin" },
      builtin = {
        relative = "editor",
        min_width = 0.99,
        win_options = {
          winblend = 0,
        },
      },
    },
  })

  require("nvim-autopairs").setup({})

  require("lualine").setup({
    extensions = { "fugitive", "quickfix" },
    sections = {
      lualine_b = { "FugitiveHead" },
      lualine_c = {
        {
          "filename",
          path = 1,
        },
      },
    },
  })

  require("neoscroll").setup({
    duration_multiplier = 2.0,
  })

  require("dashboard").setup({
    theme = "hyper",
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        { desc = "󰊳 Update", group = "@property", action = "PackUpdate", key = "u" },
        {
          icon = " ",
          icon_hl = "@variable",
          desc = "Files",
          group = "Label",
          action = function()
            require("es.pack").load("telescope")
            require("telescope.builtin").find_files({
              follow = true,
              hidden = false,
            })
          end,
          key = "f",
        },
        {
          icon = " ",
          icon_hl = "@variable",
          desc = "Search",
          group = "Label",
          action = function()
            require("es.pack").load("telescope")
            require("telescope").extensions.live_grep_args.live_grep_args()
          end,
          key = "s",
        },
        {
          icon = "󰀶 ",
          icon_hl = "@variable",
          desc = "Browse",
          group = "Label",
          action = function()
            require("es.pack").load("telescope")
            require("telescope").extensions.file_browser.file_browser()
          end,
          key = "b",
        },
      },
      project = {
        enable = false,
      },
    },
  })
end

return M
