local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
if not has_telescope_builtin then
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

local has_telescope_previewers, telescope_previewers = pcall(require, "telescope.previewers")
if not has_telescope_previewers then
  return
end

local has_plenary_job, plenary_job = pcall(require, "plenary.job")
if not has_plenary_job then
  return
end

local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  plenary_job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        telescope_previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

telescope.setup {
  defaults = {
    prompt_prefix = "🔍 ",
    file_ignore_patterns = { "node_modules" },
    buffer_previewer_maker = new_maker,
    layout_config = {
      width = 0.99
    },
    preview = {
      treesitter = {
        disable = {
          "javascript"
        }
      }
    }
  },
  pickers = {
    live_grep = {
      additional_args = function()
        return { "--hidden" }
      end
    },
  },
}

local has_fzf, _ = pcall(telescope.load_extension, "fzf")
if not has_fzf then
  return
end

local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files hidden=true<CR>", opt)
vim.keymap.set("n", "<Leader>fF", "<Cmd>Telescope find_files<CR>", opt)
vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope git_files<CR>", opt)
vim.keymap.set("n", "<Leader>fs", "<Cmd>Telescope grep_string<CR>", opt)
vim.keymap.set("n", "<Leader>rg", "<Cmd>Telescope live_grep<CR>", opt)
vim.keymap.set("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", opt)
vim.keymap.set("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>", opt)

vim.keymap.set("n", "<Leader>fr", telescope.extensions.frecency.frecency, opt)
vim.keymap.set("n", "<Leader>fe", telescope.extensions.file_browser.file_browser, opt)
vim.keymap.set("n", "<Leader>fE", "<Cmd>Telescope file_browser respect_gitignore=false<CR>", opt)
