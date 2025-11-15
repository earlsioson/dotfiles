local HEIGHT_RATIO = 1
local WIDTH_RATIO = 1
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = {
        float = {
          enable = true,
          quit_on_focus_loss = false,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
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
    },
    -- Oil keymaps are centralized in es.keymaps
  },
  {
    "stevearc/dressing.nvim",
    opts = {
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
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        extensions = { "fugitive", "nvim-dap-ui", "quickfix" },
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
    end,
  },
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    opts = {
      border = "rounded",
    },
    -- Glow keymaps are centralized in es.keymaps
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      duration_multiplier = 2.0,
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = {
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = "Telescope find_files",
            key = "f",
          },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Search",
            group = "Label",
            action = "Telescope live_grep_args",
            key = "s",
          },
          {
            icon = "󰀶 ",
            icon_hl = "@variable",
            desc = "Browse",
            group = "Label",
            action = "Telescope file_browser",
            key = "b",
          },
        },
        project = {
          enable = false,
        },
      },
    },
  },
}
