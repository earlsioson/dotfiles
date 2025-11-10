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
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeFocus",
      "NvimTreeFindFile",
    },
    opts = function()
      local api = require("nvim-tree.api")
      local function on_attach(bufnr)
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "<C-k>", { buffer = bufnr })
        vim.keymap.set("n", "<M-i>", api.node.show_info_popup, {
          desc = "nvim-tree: Info",
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end

      return {
        on_attach = on_attach,
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = false,
        },
        renderer = {
          symlink_destination = false,
        },
        view = {
          relativenumber = true,
          width = 40,
        },
      }
    end,
    keys = {
      { "<Leader>nt", "<Cmd>NvimTreeToggle<CR>", desc = "NvimTree toggle" },
      { "<Leader>nf", "<Cmd>NvimTreeFindFile<CR>", desc = "NvimTree find file" },
      {
        "<Leader>no",
        function()
          vim.ui.input({
            prompt = "Open: ",
            default = "",
            completion = "dir",
          }, function(input)
            if not input or input == "" then
              return
            end
            require("nvim-tree.api").tree.open({ path = input })
          end)
        end,
        desc = "NvimTree open dir",
      },
      { "<Leader>nc", "<Cmd>NvimTreeClose<CR>", desc = "NvimTree close" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Oil parent directory" },
    },
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
    keys = {
      { "<Leader>mp", "<Cmd>Glow<CR>", desc = "Markdown preview" },
    },
  },
  {
    "karb94/neoscroll.nvim",
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
