-- ============================================================================
-- Centralized Keymaps
-- ============================================================================
-- All Neovim keymaps in one place for easy reference and learning
-- Shared vim/neovim keymaps live in ~/.vim/common.vim

local map = vim.keymap.set

-- ============================================================================
-- Vim Conventions (Built-in, no leader required)
-- ============================================================================
-- Standard vim/LSP conventions that reduce cognitive load

-- LSP Navigation
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Navigation (vim-unimpaired style)
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
-- ]c and [c for git hunks are defined in git plugin

-- ============================================================================
-- Code Operations (<Leader>c* = "code")
-- ============================================================================
-- Actions for modifying, analyzing, and navigating code

map("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<Leader>cr", vim.lsp.buf.rename, { desc = "Code rename" })
map("n", "<Leader>cf", vim.lsp.buf.format, { desc = "Code format" })
map("n", "<Leader>cs", vim.lsp.buf.signature_help, { desc = "Code signature help" })
map("n", "<Leader>ct", vim.lsp.buf.type_definition, { desc = "Code type definition" })

map("n", "<Leader>ci", function()
  local inlay = vim.lsp.inlay_hint
  if inlay and inlay.is_enabled and inlay.enable then
    local bufnr = vim.api.nvim_get_current_buf()
    local enabled = inlay.is_enabled({ bufnr = bufnr })
    inlay.enable(not enabled, { bufnr = bufnr })
  end
end, { desc = "Code inlay hints (toggle)" })

map("n", "<Leader>cx", function()
  require("treesitter-context").go_to_context()
end, { desc = "Code context jump (treesitter)" })

-- ============================================================================
-- Debug Operations (<Leader>d* = "debug")
-- ============================================================================
-- DAP debugger controls

map("n", "<Leader>dc", function() require("dap").continue() end, { desc = "Debug continue" })
map("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug breakpoint (toggle)" })
map("n", "<Leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug breakpoint (conditional)" })
map("n", "<Leader>ds", function() require("dap").step_over() end, { desc = "Debug step over" })
map("n", "<Leader>di", function() require("dap").step_into() end, { desc = "Debug step into" })
map("n", "<Leader>do", function() require("dap").step_out() end, { desc = "Debug step out" })
map("n", "<Leader>dt", function() require("dap").terminate() end, { desc = "Debug terminate" })
map("n", "<Leader>dr", function() require("dap").repl.open() end, { desc = "Debug REPL" })
map("n", "<Leader>du", function() require("dapui").toggle() end, { desc = "Debug UI (toggle)" })
map("n", "<Leader>dv", function()
  require("dap.ext.vscode").load_launchjs(nil, { lldb = { "c", "cpp", "rust", "zig" } })
end, { desc = "Debug load vscode config" })
map("n", "<Leader>dl", function() require("dap").run_last() end, { desc = "Debug run last" })
map("n", "<Leader>dk", function() require("dap").clear_breakpoints() end, { desc = "Debug kill all breakpoints" })

-- Debug inspection
map({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Debug hover variables" })
map({ "n", "v" }, "<Leader>dw", function() require("dapui").float_element("watches") end, { desc = "Debug watches" })
map("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Debug frames" })
map("n", "<Leader>dp", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Debug preview scopes" })

-- ============================================================================
-- Find Operations (<Leader>f* = "find")
-- ============================================================================
-- Telescope pickers for finding files, text, and symbols
-- Uses ripgrep for text search and fd for file finding

map("n", "<Leader>ff", "<Cmd>Telescope find_files follow=true hidden=false<CR>", { desc = "Find files" })
map("n", "<Leader>fr", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Find with ripgrep (live grep)" })
map("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<Leader>fg", "<Cmd>Telescope git_files<CR>", { desc = "Find git files" })
map("n", "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", { desc = "Find oldfiles (recent)" })
map("n", "<Leader>fh", function()
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = true,
    find_command = { 
      "fd", "--type", "f", "--hidden", "--no-ignore", 
      "--exclude", "node_modules",
      "--exclude", ".git",
      "--exclude", "target",        -- Rust build dir
      "--exclude", "dist",          -- Common build output
      "--exclude", "build",         -- Common build output
      "--exclude", ".next",         -- Next.js
      "--exclude", "__pycache__",   -- Python cache
      "--exclude", ".pytest_cache", -- pytest
      "--exclude", ".venv",         -- Python venv
      "--exclude", "venv",          -- Python venv
      "--strip-cwd-prefix" 
    }
  })
end, { desc = "Find hidden files (including gitignored)" })
map("n", "<Leader>fw", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Find workspace symbols" })
map("n", "<Leader>fd", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Find document symbols" })
map("n", "<Leader>fk", "<Cmd>Telescope keymaps<CR>", { desc = "Find keymaps" })

-- File browser
map("n", "<Leader>fe", function()
  require("telescope").extensions.file_browser.file_browser()
end, { desc = "Find explorer (file browser)" })
map("n", "<Leader>fE", "<Cmd>Telescope file_browser respect_gitignore=false<CR>",
  { desc = "Find explorer all (no gitignore)" })

-- ============================================================================
-- Git Operations (<Leader>g* = "git")
-- ============================================================================
-- Git operations via fugitive and gitsigns

-- Fugitive
map("n", "<Leader>gg", "<Cmd>G | only<CR>", { desc = "Git status" })

-- Gitsigns hunks
map("n", "<Leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Git stage hunk" })
map("n", "<Leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Git reset hunk" })
map("v", "<Leader>gs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Git stage hunk (visual)" })
map("v", "<Leader>gr", function()
  require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Git reset hunk (visual)" })
map("n", "<Leader>gS", function() require("gitsigns").stage_buffer() end, { desc = "Git stage buffer" })
map("n", "<Leader>gR", function() require("gitsigns").reset_buffer() end, { desc = "Git reset buffer" })
map("n", "<Leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Git undo stage" })
map("n", "<Leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Git preview hunk" })
map("n", "<Leader>gb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Git blame line" })
map("n", "<Leader>gt", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Git toggle blame" })
map("n", "<Leader>gx", function() require("gitsigns").toggle_deleted() end, { desc = "Git toggle deleted" })
map("n", "<Leader>gd", function() require("gitsigns").diffthis() end, { desc = "Git diff" })
map("n", "<Leader>gD", function() require("gitsigns").diffthis("~") end, { desc = "Git diff against ~" })

-- Hunk navigation (vim-unimpaired style)
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ args = "]c", bang = true })
  else
    require("gitsigns").nav_hunk("next")
  end
end, { desc = "Next git hunk" })
map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ args = "[c", bang = true })
  else
    require("gitsigns").nav_hunk("prev")
  end
end, { desc = "Previous git hunk" })

-- Hunk text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git hunk text object" })

-- ============================================================================
-- Diagnostics (<Leader>x* = "fix")
-- ============================================================================
-- LSP diagnostic management

map("n", "<Leader>xx", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<Leader>xl", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map("n", "<Leader>xs", vim.diagnostic.show, { desc = "Diagnostic show" })
map("n", "<Leader>xh", vim.diagnostic.hide, { desc = "Diagnostic hide" })

-- ============================================================================
-- Flash Navigation
-- ============================================================================
-- Flash keymaps are defined in the plugin spec for lazy loading

-- ============================================================================
-- NvimTree (<Leader>n* = "nvimtree")
-- ============================================================================
-- File tree navigation

map("n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>", { desc = "NvimTree toggle" })
map("n", "<Leader>nf", "<Cmd>NvimTreeFindFile<CR>", { desc = "NvimTree find file" })
map("n", "<Leader>no", function()
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
end, { desc = "NvimTree open dir" })
map("n", "<Leader>nc", "<Cmd>NvimTreeClose<CR>", { desc = "NvimTree close" })

-- ============================================================================
-- Other Mappings
-- ============================================================================

-- Oil
map("n", "-", "<CMD>Oil<CR>", { desc = "Oil parent directory" })

-- Markdown preview
map("n", "<Leader>mp", "<Cmd>Glow<CR>", { desc = "Markdown preview" })

-- Copilot
map("n", "<Leader>cT", "<Cmd>Copilot toggle<CR>", { desc = "Copilot toggle" })
