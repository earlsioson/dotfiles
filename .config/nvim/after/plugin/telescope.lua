local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
if not has_telescope_builtin then
  return
end

local has_telescope_actions, telescope_actions = pcall(require, "telescope.actions")
if not has_telescope_actions then
  return
end

local has_telescope_actions_set, telescope_actions_set = pcall(require, "telescope.actions.set")
if not has_telescope_actions_set then
  return
end

local has_telescope_actions_state, telescope_actions_state = pcall(require, "telescope.actions.state")
if not has_telescope_actions_state then
  return
end

local has_frecency, _ = pcall(telescope.load_extension, "frecency")
if not has_frecency then
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
    buffers = fixfolds,
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

local find_in_repos = function()
  local vim_edit_prompt = function(prompt_bufnr)
    local current_picker = telescope_actions_state.get_current_picker(prompt_bufnr)
    local prompt = current_picker:_get_prompt()
    local cwd = current_picker.cwd
    telescope_actions.close(prompt_bufnr)
    vim.api.nvim_exec(':edit ' .. cwd .. '/' .. prompt, false)
    return true
  end

  telescope_builtin.find_files({
    prompt_title = "< my_find >",
    cwd = "~/dev/e2g/repos",
    hidden = true,
    no_ignore = true,
    attach_mappings = function(_, map)
      map('i', '<c-n>', vim_edit_prompt)
      return true
    end
  })
end

local search_dir = function()
  vim.ui.input({
      prompt = "Search: ",
      default = "",
      completion = "file",
    },
    function(input)
      telescope.extensions.live_grep_args.live_grep_args({ search_dirs = { input } })
    end)
end

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files follow=true<CR>", opt)
vim.keymap.set("n", "<Leader>fF", "<Cmd>Telescope find_files follow=true hidden=true<CR>", opt)
vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope git_files<CR>", opt)
vim.keymap.set("n", "<Leader>fs", "<Cmd>Telescope grep_string<CR>", opt)
vim.keymap.set("n", "<Leader>rg", search_dir, opt)
vim.keymap.set("n", "<Leader><Leader>rg", telescope.extensions.live_grep_args.live_grep_args, opt)
vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", opt)
vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>", opt)

vim.keymap.set("n", "<Leader>fR", find_in_repos, opt)
vim.keymap.set("n", "<Leader>fr", telescope.extensions.frecency.frecency, opt)
vim.keymap.set("n", "<Leader>fe", telescope.extensions.file_browser.file_browser, opt)
vim.keymap.set("n", "<Leader>fE", "<Cmd>Telescope file_browser respect_gitignore=false<CR>", opt)
