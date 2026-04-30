-- ============================================================================
-- Centralized Keymaps
-- ============================================================================
-- All Neovim keymaps in one place for easy reference and learning
-- Shared vim/neovim keymaps live in ~/.vim/common.vim

local M = {}
local map = vim.keymap.set

local function load_feature(name)
  require("es.pack").load(name)
end

-- ============================================================================
-- Gitsigns Keymaps (exported for on_attach callback)
-- ============================================================================
-- These keymaps are buffer-local and only active in git-tracked files
M.setup_gitsigns_keymaps = function(gs, bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({']c', bang = true})
    else
      gs.nav_hunk('next')
    end
  end)

  map('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({'[c', bang = true})
    else
      gs.nav_hunk('prev')
    end
  end)

  -- Actions
  map('n', '<leader>hs', gs.stage_hunk)
  map('n', '<leader>hr', gs.reset_hunk)
  map('v', '<leader>hs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end)
  map('v', '<leader>hr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end)
  map('n', '<leader>hS', gs.stage_buffer)
  map('n', '<leader>hR', gs.reset_buffer)
  map('n', '<leader>hu', gs.undo_stage_hunk)
  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hi', gs.preview_hunk_inline)
  map('n', '<leader>hb', function() gs.blame_line({full = true}) end)
  map('n', '<leader>hd', gs.diffthis)
  map('n', '<leader>hD', function() gs.diffthis('~') end)
  map('n', '<leader>hQ', function() gs.setqflist('all') end)
  map('n', '<leader>hq', gs.setqflist)

  -- Toggles
  map('n', '<leader>tb', gs.toggle_current_line_blame)
  map('n', '<leader>tw', gs.toggle_word_diff)

  -- Text object
  map({'o', 'x'}, 'ih', gs.select_hunk)
end

-- ============================================================================
-- LSP Operations (<Leader>l* = "lsp")
-- ============================================================================
-- Keymaps mirror vim.lsp.buf.* API for easy memorization
-- Diagnostics use ]d/[d (Neovim 0.11 defaults) for navigation

M.setup_lsp_keymaps = function(bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map("n", "<Leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<Leader>lc", vim.lsp.buf.incoming_calls, { desc = "LSP incoming calls" })
  map("n", "<Leader>lC", vim.lsp.buf.outgoing_calls, { desc = "LSP outgoing calls" })
  map("n", "<Leader>ld", vim.lsp.buf.definition, { desc = "LSP definition" })
  map("n", "<Leader>lD", vim.lsp.buf.declaration, { desc = "LSP declaration" })
  map("n", "<Leader>lf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "LSP format (conform)" })
  map("n", "<Leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
  map("n", "<Leader>li", vim.lsp.buf.implementation, { desc = "LSP implementation" })
  map("n", "<Leader>lo", vim.lsp.buf.document_symbol, { desc = "LSP document outline" })
  map("n", "<Leader>lr", vim.lsp.buf.references, { desc = "LSP references" })
  map("n", "<Leader>ln", vim.lsp.buf.rename, { desc = "LSP rename" })
  map("n", "<Leader>ls", vim.lsp.buf.signature_help, { desc = "LSP signature help" })
  map("n", "<Leader>lt", vim.lsp.buf.type_definition, { desc = "LSP type definition" })
  map("n", "<Leader>lw", vim.lsp.buf.workspace_symbol, { desc = "LSP workspace symbols" })
end

-- ============================================================================
-- Diagnostic Operations (<Leader>d* = "diagnostics")
-- ============================================================================
-- Keymaps mirror vim.diagnostic.* API for easy memorization
-- Navigation uses ]d/[d (Neovim 0.11 defaults)

map("n", "<Leader>df", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<Leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map("n", "<Leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostic quickfix" })

-- ============================================================================
-- AI Operations (<Leader>A* = "ai")
-- ============================================================================
-- Sidekick terminal sessions for local AI CLIs.

local function sidekick_cli()
  load_feature("ai")
  return require("sidekick.cli")
end

map({ "n", "t", "i", "x" }, "<Leader>Af", function()
  sidekick_cli().focus()
end, { desc = "Sidekick focus" })
map("n", "<Leader>Aa", function()
  sidekick_cli().toggle()
end, { desc = "Sidekick toggle CLI" })
map("n", "<Leader>As", function()
  sidekick_cli().select({ filter = { installed = true } })
end, { desc = "Sidekick select CLI" })
map("n", "<Leader>Ad", function()
  sidekick_cli().close()
end, { desc = "Sidekick detach CLI" })
map({ "n", "x" }, "<Leader>At", function()
  sidekick_cli().send({ msg = "{this}" })
end, { desc = "Sidekick send this" })
map("n", "<Leader>AF", function()
  sidekick_cli().send({ msg = "{file}" })
end, { desc = "Sidekick send file" })
map("x", "<Leader>Av", function()
  sidekick_cli().send({ msg = "{selection}" })
end, { desc = "Sidekick send selection" })
map({ "n", "x" }, "<Leader>Ap", function()
  sidekick_cli().prompt()
end, { desc = "Sidekick prompt" })

-- ============================================================================
-- Debug Operations (<Leader>b* = "debug/break")
-- ============================================================================
-- DAP debugger controls

map("n", "<Leader>bc", function()
  load_feature("dap")
  require("dap").continue()
end, { desc = "Debug continue" })
map("n", "<Leader>bb", function()
  load_feature("dap")
  require("dap").toggle_breakpoint()
end, { desc = "Debug breakpoint (toggle)" })
map("n", "<Leader>bB", function()
  load_feature("dap")
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug breakpoint (conditional)" })
map("n", "<Leader>bs", function()
  load_feature("dap")
  require("dap").step_over()
end, { desc = "Debug step over" })
map("n", "<Leader>bi", function()
  load_feature("dap")
  require("dap").step_into()
end, { desc = "Debug step into" })
map("n", "<Leader>bo", function()
  load_feature("dap")
  require("dap").step_out()
end, { desc = "Debug step out" })
map("n", "<Leader>bt", function()
  load_feature("dap")
  require("dap").terminate()
end, { desc = "Debug terminate" })
map("n", "<Leader>br", function()
  load_feature("dap")
  require("dap").repl.open()
end, { desc = "Debug REPL" })
map("n", "<Leader>bu", function()
  load_feature("dap")
  require("dapui").toggle()
end, { desc = "Debug UI (toggle)" })
map("n", "<Leader>bv", function()
  load_feature("dap")
  require("dap.ext.vscode").load_launchjs(nil, { lldb = { "c", "cpp", "rust", "zig" } })
end, { desc = "Debug load vscode config" })
map("n", "<Leader>bl", function()
  load_feature("dap")
  require("dap").run_last()
end, { desc = "Debug run last" })
map("n", "<Leader>bk", function()
  load_feature("dap")
  require("dap").clear_breakpoints()
end, { desc = "Debug kill all breakpoints" })

-- Debug inspection
map({ "n", "v" }, "<Leader>bh", function()
  load_feature("dap")
  require("dap.ui.widgets").hover()
end, { desc = "Debug hover variables" })
map({ "n", "v" }, "<Leader>bw", function()
  load_feature("dap")
  require("dapui").float_element("watches")
end, { desc = "Debug watches" })
map("n", "<Leader>bf", function()
  load_feature("dap")
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Debug frames" })
map("n", "<Leader>bp", function()
  load_feature("dap")
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Debug preview scopes" })

-- ============================================================================
-- Find Operations (<Leader>f* = "find")
-- ============================================================================
-- Telescope pickers for finding files, text, and symbols
-- Uses ripgrep for text search and fd for file finding

local fd_excludes = {
  "node_modules",
  ".git",
  "target",        -- Rust build dir
  "dist",          -- Common build output
  "build",         -- Common build output
  ".next",         -- Next.js
  "__pycache__",   -- Python cache
  ".pytest_cache", -- pytest
  ".venv",         -- Python venv
  "venv",          -- Python venv
}

local function fd_command(node_type)
  local args = { "fd" }
  if node_type then
    table.insert(args, "--type")
    table.insert(args, node_type)
  end
  vim.list_extend(args, { "--hidden", "--no-ignore" })
  for _, pattern in ipairs(fd_excludes) do
    vim.list_extend(args, { "--exclude", pattern })
  end
  table.insert(args, "--strip-cwd-prefix")
  return args
end

map("n", "<Leader>ff", function()
  load_feature("telescope")
  require("telescope.builtin").find_files({
    follow = true,
    hidden = false,
  })
end, { desc = "Find files" })
map("n", "<Leader>fr", function()
  load_feature("telescope")
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Find with ripgrep (live grep)" })
map("n", "<Leader>fb", function()
  load_feature("telescope")
  require("telescope.builtin").buffers()
end, { desc = "Find buffers" })
map("n", "<Leader>fg", function()
  load_feature("telescope")
  require("telescope.builtin").git_files()
end, { desc = "Find git files" })
map("n", "<Leader>fo", function()
  load_feature("telescope")
  require("telescope.builtin").oldfiles()
end, { desc = "Find oldfiles (recent)" })
map("n", "<Leader>fh", function()
  load_feature("telescope")
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = true,
    find_command = fd_command("f"),
  })
end, { desc = "Find hidden files (including gitignored)" })
map("n", "<Leader>fw", function()
  load_feature("telescope")
  require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Find workspace symbols" })
map("n", "<Leader>fd", function()
  load_feature("telescope")
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Find document symbols" })
map("n", "<Leader>fk", function()
  load_feature("telescope")
  require("telescope.builtin").keymaps()
end, { desc = "Find keymaps" })

-- File browser
map("n", "<Leader>fe", function()
  load_feature("telescope")
  require("telescope").extensions.file_browser.file_browser()
end, { desc = "Find explorer (file browser)" })
map("n", "<Leader>fE", function()
  load_feature("telescope")
  require("telescope").extensions.file_browser.file_browser({
    respect_gitignore = false,
  })
end, { desc = "Find explorer all (no gitignore)" })

map("n", "<Leader>fD", function()
  load_feature("telescope")
  load_feature("explorer")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local oil = require("oil")
  local cwd = vim.fn.getcwd()

  require("telescope.builtin").find_files({
    prompt_title = "Directories",
    cwd = cwd,
    hidden = true,
    no_ignore = true,
    follow = true,
    find_command = fd_command("d"),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          local path = selection.path or selection.value
          oil.open(path or cwd)
        end
      end)
      return true
    end,
  })
end, { desc = "Oil open directory (finder)" })

-- ============================================================================
-- Git Operations (<Leader>g* = "git")
-- ============================================================================
-- Gitsigns keymaps (<Leader>h*, <Leader>t*, ]c, [c, ih) are defined in
-- plugins/gitsigns.lua on_attach callback (buffer-local, only in git files)

-- Fugitive
map("n", "<Leader>gg", "<Cmd>G | only<CR>", { desc = "Git status" })

-- ============================================================================
-- Flash Navigation
-- ============================================================================
-- Flash keymaps are defined in the plugin spec for lazy loading

-- ============================================================================
-- NvimTree (<Leader>e* = "explorer")
-- ============================================================================
-- File tree navigation

map("n", "<Leader>et", function()
  load_feature("explorer")
  vim.cmd.NvimTreeToggle()
end, { desc = "NvimTree toggle" })
map("n", "<Leader>ef", function()
  load_feature("explorer")
  require("nvim-tree.api").tree.find_file({ buf = vim.api.nvim_get_current_buf(), open = true, focus = true })
end, { desc = "NvimTree find file" })
map("n", "<Leader>ec", function()
  load_feature("explorer")
  vim.cmd.NvimTreeClose()
end, { desc = "NvimTree close" })
map("n", "<Leader>ep", function()
  load_feature("explorer")
  local parent_dir = vim.fn.expand("%:p:h")
  require("nvim-tree.api").tree.open({ path = parent_dir })
end, { desc = "NvimTree open parent directory" })

-- ============================================================================
-- Other Mappings
-- ============================================================================

map("n", "-", function()
  load_feature("explorer")
  vim.cmd.Oil()
end, { desc = "Oil parent directory" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    map("n", "<Leader>eo", function()
      local dir = require("oil").get_current_dir(0)
      if not dir then
        return
      end
      require("nvim-tree.api").tree.open({ path = dir, focus = true })
    end, { buffer = true, desc = "NvimTree open Oil directory" })
  end,
})

map("n", "<Leader>mp", function()
  load_feature("explorer")
  vim.cmd.Glow()
end, { desc = "Markdown preview" })

return M
