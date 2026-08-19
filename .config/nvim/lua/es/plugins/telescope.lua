local M = {}

function M.setup()
  local actions = require("telescope.actions")
  local actions_set = require("telescope.actions.set")
  local telescope = require("telescope")
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

  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules" },
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
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          width = 0.95,
          height = 0.90,
          preview_width = 0.58,
        },
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
      git_bcommits = vim.tbl_deep_extend("force", {}, fixfolds, {
        attach_mappings = function(prompt_bufnr, map)
          local action_state = require("telescope.actions.state")
          local function open_commit_file(cmd)
            return function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if selection and selection.value then
                local file = selection.current_file or "%"
                vim.cmd(cmd .. " " .. selection.value .. ":" .. file)
              end
            end
          end

          actions.select_default:replace(open_commit_file("Gedit"))
          actions.select_horizontal:replace(open_commit_file("Gsplit"))
          actions.select_vertical:replace(open_commit_file("Gvsplit"))
          actions.select_tab:replace(open_commit_file("Gtabedit"))
          return true
        end,
      }),
      git_commits = vim.tbl_deep_extend("force", {}, fixfolds, {
        attach_mappings = function(prompt_bufnr, map)
          local action_state = require("telescope.actions.state")
          local function open_commit(cmd)
            return function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if selection and selection.value then
                vim.cmd(cmd .. " " .. selection.value)
              end
            end
          end

          actions.select_default:replace(open_commit("Gedit"))
          actions.select_horizontal:replace(open_commit("Gsplit"))
          actions.select_vertical:replace(open_commit("Gvsplit"))
          actions.select_tab:replace(open_commit("Gtabedit"))
          return true
        end,
      }),
      git_files = fixfolds,
      grep_string = fixfolds,
      live_grep = fixfolds,
      oldfiles = fixfolds,
    },
  })

  telescope.load_extension("file_browser")
  telescope.load_extension("live_grep_args")
  pcall(telescope.load_extension, "fzf")
end

return M
