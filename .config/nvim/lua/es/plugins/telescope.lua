return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local actions_set = require("telescope.actions.set")
      local fixfolds = {
        hidden = true,
        attach_mappings = function()
          actions_set.select:enhance({
            post = function()
              vim.cmd("normal! zx")
            end,
          })
          return true
        end,
      }

      return {
        defaults = {
          prompt_prefix = "🔍 ",
          file_ignore_patterns = { "node_modules" },
          layout_config = {
            width = 0.99,
          },
          preview = {
            treesitter = {
              disable = { "javascript" },
            },
          },
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--follow",
            "-.",
            "-g",
            "!.git",
          },
        },
        pickers = {
          buffers = vim.tbl_deep_extend("force", {}, fixfolds, {
            mappings = {
              i = {
                ["<M-d>"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          }),
          file_browser = vim.tbl_deep_extend("force", {}, fixfolds, {
            use_fd = true,
          }),
          find_files = vim.tbl_deep_extend("force", {}, fixfolds, {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          }),
          git_files = fixfolds,
          grep_string = fixfolds,
          live_grep = fixfolds,
          oldfiles = fixfolds,
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("file_browser")
      telescope.load_extension("live_grep_args")
      pcall(telescope.load_extension, "fzf")
    end,
    -- Telescope keymaps are centralized in es.keymaps
  },
}
