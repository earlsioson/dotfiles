local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local has_telescope_actions, telescope_actions = pcall(require, "telescope.actions")
if not has_telescope_actions then
  return
end

local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
if not has_telescope_builtin then
  return
end

local has_telescope_actions_set, telescope_actions_set = pcall(require, "telescope.actions.set")
if not has_telescope_actions_set then
  return
end

local has_file_browser, _ = pcall(telescope.load_extension, "file_browser")
if not has_file_browser then
  return
end

local has_live_grep_args, _ = pcall(telescope.load_extension, "live_grep_args")
if not has_live_grep_args then
  return
end

local has_session_lens, session_lens = pcall(require, "auto-session.session-lens")
if not has_session_lens then
  return
end
telescope.load_extension("session-lens")

-- https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-934727312
-- fixes problem with folds not working when opened via telescope
local fixfolds = {
  hidden = true,
  attach_mappings = function(_)
    telescope_actions_set.select:enhance({
      post = function()
        vim.cmd(":normal! zx")
      end,
    })
    return true
  end,
}

telescope.setup {
  defaults = {
    prompt_prefix = "🔍 ",
    file_ignore_patterns = { "node_modules" },
    layout_config = {
      width = 0.99
    },
    preview = {
      treesitter = {
        disable = {
          "javascript"
        }
      }
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
      "!.git"
    },
  },
  pickers = {
    buffers = {
      unpack(fixfolds),
      mappings = {
        i = {
          ["<M-d>"] = telescope_actions.delete_buffer + telescope_actions.move_to_top,
        }
      }
    },
    file_browser = fixfolds,
    find_files = fixfolds,
    git_files = fixfolds,
    grep_string = fixfolds,
    live_grep = fixfolds,
    oldfiles = fixfolds,
  },
}

local has_fzf, _ = pcall(telescope.load_extension, "fzf")
if not has_fzf then
  return
end

local search_dir = function()
  vim.ui.input({
      prompt = "Search: ",
      default = "",
      completion = "dir",
    },
    function(input)
      telescope.extensions.live_grep_args.live_grep_args({ search_dirs = { input } })
    end)
end

local find_dir = function()
  vim.ui.input({
      prompt = "Find: ",
      default = "",
      completion = "dir",
    },
    function(input)
      print(input)
      telescope_builtin.find_files({ search_dirs = { input }, follow = true, hidden = true })
    end)
end

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>fp", session_lens.search_session, opt)
vim.keymap.set("n", "<Leader><Leader>ff", find_dir, opt)
vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files follow=true hidden=false<CR>", opt)
vim.keymap.set("n", "<Leader>fd", "<Cmd>Telescope lsp_document_symbols<CR>", opt)
vim.keymap.set("n", "<Leader>fw", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opt)
vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope git_files<CR>", opt)
vim.keymap.set("n", "<Leader>fs", "<Cmd>Telescope grep_string<CR>", opt)
vim.keymap.set("n", "<Leader><Leader>rg", search_dir, opt)
vim.keymap.set("n", "<Leader>rg", telescope.extensions.live_grep_args.live_grep_args, opt)
vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", opt)
vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>", opt)

vim.keymap.set("n", "<Leader>fe", telescope.extensions.file_browser.file_browser, opt)
vim.keymap.set("n", "<Leader><Leader>fe", "<Cmd>Telescope file_browser respect_gitignore=false<CR>", opt)
