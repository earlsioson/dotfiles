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
          buffers = vim.tbl_deep_extend("force", vim.deepcopy(fixfolds), {
            mappings = {
              i = {
                ["<M-d>"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          }),
          file_browser = fixfolds,
          find_files = fixfolds,
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
    keys = {
      {
        "<Leader><Leader>ff",
        function()
          vim.ui.input({
            prompt = "Find: ",
            default = "",
            completion = "dir",
          }, function(input)
            if not input or input == "" then
              return
            end
            require("telescope.builtin").find_files({
              search_dirs = { input },
              follow = true,
              hidden = true,
            })
          end)
        end,
        desc = "Find files (prompt directory)",
      },
      {
        "<Leader>fh",
        "<Cmd>Telescope find_files follow=true hidden=true no_ignore=true<CR>",
        desc = "Find hidden files",
      },
      {
        "<Leader>ff",
        "<Cmd>Telescope find_files follow=true hidden=false<CR>",
        desc = "Find files",
      },
      {
        "<Leader>fd",
        "<Cmd>Telescope lsp_document_symbols<CR>",
        desc = "Document symbols",
      },
      {
        "<Leader>fw",
        "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
        desc = "Workspace symbols",
      },
      {
        "<Leader>fg",
        "<Cmd>Telescope git_files<CR>",
        desc = "Git files",
      },
      {
        "<Leader>fs",
        "<Cmd>Telescope grep_string<CR>",
        desc = "Grep string",
      },
      {
        "<Leader><Leader>rg",
        function()
          vim.ui.input({
            prompt = "Search: ",
            default = "",
            completion = "dir",
          }, function(input)
            if not input or input == "" then
              return
            end
            require("telescope").extensions.live_grep_args.live_grep_args({
              search_dirs = { input },
            })
          end)
        end,
        desc = "Live grep (prompt directory)",
      },
      {
        "<Leader>rg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live grep",
      },
      {
        "<Leader>fo",
        "<Cmd>Telescope oldfiles<CR>",
        desc = "Recent files",
      },
      {
        "<Leader>fb",
        "<Cmd>Telescope buffers<CR>",
        desc = "Buffers",
      },
      {
        "<Leader>fk",
        "<Cmd>Telescope keymaps<CR>",
        desc = "Keymaps",
      },
      {
        "<Leader>fe",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = "File browser",
      },
      {
        "<Leader><Leader>fe",
        "<Cmd>Telescope file_browser respect_gitignore=false<CR>",
        desc = "File browser (no gitignore)",
      },
    },
  },
}
