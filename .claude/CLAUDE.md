# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a personal dotfiles repository containing configuration for Neovim, Vim, tmux, and CLI tools. The primary focus is a modern Neovim setup with comprehensive LSP, debugging, and AI assistance capabilities.

## Neovim Architecture

### Configuration Structure

```
.config/nvim/
├── init.lua                 # Entry point: loads modules in sequence
├── lsp/                     # LSP server configs (auto-discovered by vim.lsp.config)
│   ├── lua_ls.lua          # Lua language server settings
│   ├── pyright.lua         # Python language server settings
│   ├── rust_analyzer.lua   # Rust language server settings
│   └── ...                 # One file per server (16 total)
├── lua/es/
│   ├── globals.lua         # Global utilities, Python paths, Lua compatibility
│   ├── lazy.lua            # lazy.nvim plugin manager bootstrap
│   ├── options.lua         # Editor options (folding, clipboard, tmux integration)
│   ├── keymaps.lua         # Custom keymaps (Neovim 0.11 defaults documented)
│   ├── autocmds.lua        # Autocommands
│   ├── ui.lua              # UI configuration
│   └── plugins/            # Plugin configs (auto-loaded by lazy.nvim)
│       ├── lsp.lua         # Mason + LSP setup (minimal, uses lsp/ folder)
│       ├── telescope.lua   # Fuzzy finder + extensions
│       ├── treesitter.lua  # Syntax parsing
│       ├── cmp.lua         # Completion engine
│       ├── dap.lua         # Debug Adapter Protocol
│       ├── git.lua         # gitsigns
│       └── ...
```

### Key Architectural Principles

1. **Centralized Keymaps**: ALL keymaps live in `lua/es/keymaps.lua`. This makes discovery and learning easier.

2. **API-Mirroring Keymaps**: Keymaps mirror the Neovim API structure for easy memorization:
   - `<Leader>l*` mirrors `vim.lsp.buf.*` methods (la=action, ld=definition, lf=format, lh=hover, etc.)
   - `<Leader>d*` mirrors `vim.diagnostic.*` methods (df=float, dl=loclist, dq=quickfix)
   - Diagnostic navigation uses Neovim 0.11 defaults: `]d`/`[d` (next/prev), `]D`/`[D` (first/last)

3. **Modular Plugin Loading**: Each file in `lua/es/plugins/*.lua` returns a lazy.nvim plugin spec. The plugin manager auto-discovers and loads them.

4. **LSP Configuration via lsp/ Folder**: Server-specific configs live in `.config/nvim/lsp/*.lua` and are auto-discovered by `vim.lsp.config`. Each file returns a config table that merges with nvim-lspconfig defaults.

5. **Namespace Organization**:
   - Neovim defaults: `]d`/`[d`/`]D`/`[D` (diagnostics), `]c`/`[c` (git hunks)
   - `<Leader>l*` = LSP operations (mirrors `vim.lsp.buf.*` API)
   - `<Leader>d*` = Diagnostic operations (mirrors `vim.diagnostic.*` API)
   - `<Leader>b*` = Debug/breakpoint operations (DAP)
   - `<Leader>f*` = Find operations (Telescope)
   - `<Leader>h*` = Hunk operations (gitsigns - buffer-local in git files)
   - `<Leader>t*` = Toggle operations (gitsigns - buffer-local)
   - `<Leader>g*` = Git operations (Fugitive only)
   - `<Leader>n*` = NvimTree

6. **Gitsigns Keymap Pattern**: Gitsigns keymaps are defined in `keymaps.lua` as an exported function `M.setup_gitsigns_keymaps()`, then imported and called in `plugins/gitsigns.lua` `on_attach` callback. This maintains keymap centralization while respecting gitsigns' requirement for buffer-local keymaps.

7. **Shared Vim/Neovim Config**: `.vim/common.vim` contains settings used by both classic Vim and Neovim to avoid duplication.

8. **Python Path Centralization**: Python host path is defined once in `globals.lua` (`vim.g.python_host_path`) and reused by both the Neovim provider and DAP configurations.

9. **Lua Compatibility**: `globals.lua` sets `_G.unpack = _G.unpack or table.unpack` to handle Lua 5.1/LuaJIT vs Lua 5.2+ differences globally.

10. **Neovim API Compatibility**: The config targets Neovim 0.11+ and uses modern APIs:
   - `vim.uv` for async operations (with `vim.loop` fallback for 0.9 compatibility)
   - `vim.lsp.config()` + `vim.lsp.enable()` for LSP setup (Neovim 0.11+)
   - `vim.diagnostic.jump()` for diagnostic navigation (replaces deprecated goto_next/goto_prev)
   - Tree-sitter expression-based folding
   - Current as of Neovim 0.11.5

### Bootstrap Sequence (init.lua)

1. Enable `vim.loader` for bytecode caching
2. Set leader key to `<Space>`
3. Load `globals.lua` (Python paths, utilities, Lua compat)
4. Disable unused providers (Perl, Ruby, Python 2)
5. Source shared `.vim/common.vim` if it exists
6. Load core modules: `options`, `keymaps`, `autocmds`, `ui`
7. Load `lazy.lua` which bootstraps and loads all plugins

### LSP Configuration

- **Servers**: Managed via Mason and auto-installed: `cssls`, `docker_compose_language_service`, `dockerls`, `gopls`, `html`, `jsonls`, `lua_ls`, `oxlint`, `pyright`, `ruff`, `rust_analyzer`, `tailwindcss`, `terraformls`, `ts_ls`, `vimls`, `yamlls`
- **Setup**: `lua/es/plugins/lsp.lua` configures Mason and calls `vim.lsp.enable()` for each server
- **Configuration**: Server-specific settings live in `lsp/*.lua` files (e.g., `lsp/lua_ls.lua` for Lua language server). These are auto-discovered by Neovim 0.11's `vim.lsp.config` and merged with nvim-lspconfig defaults.
- **Keymaps**: Custom LSP keymaps in `keymaps.lua` under `<Leader>l*` namespace, mirroring `vim.lsp.buf.*` API methods for easy memorization.

### DAP (Debugger) Configuration

- **Adapters**: Python (`debugpy`), Go (`delve`), C/C++/Rust (`codelldb`), JS/TS (`js-debug-adapter`)
- **Setup**: `lua/es/plugins/dap.lua` with mason-nvim-dap for auto-installation
- **Python**: Uses the venv defined in `globals.lua`
- **Keymaps**: Debug keymaps under `<Leader>b*` namespace

### Gitsigns Configuration

- **Plugin**: `lewis6991/gitsigns.nvim` for git integration
- **Keymaps**: Defined in `keymaps.lua` as `M.setup_gitsigns_keymaps()` function, imported and called in `plugins/gitsigns.lua` on_attach callback
- **Namespace**: `<Leader>h*` for hunk operations, `<Leader>t*` for toggles, `]c`/`[c` for navigation
- **Buffer-local**: Keymaps only active in git-tracked files

### Tree-sitter Configuration

- Uses `prefer_git = true` to download pre-built parsers (more reliable than compiling)
- Auto-installs on first Neovim launch
- Folding configured via Tree-sitter expressions in `options.lua`

## Making Changes

### Adding/Modifying Keymaps

**DO**: Edit `lua/es/keymaps.lua` to add or change keymaps.
**DON'T**: Add keymaps inside plugin configuration files (except for buffer-local keymaps that require on_attach callbacks).

**For global keymaps:**
```lua
-- In lua/es/keymaps.lua
map('n', '<Leader>cx', '<cmd>SomeCommand<cr>', { desc = 'Code: Some action' })
```

**For buffer-local keymaps (like gitsigns):**
```lua
-- In lua/es/keymaps.lua
M.setup_plugin_keymaps = function(plugin_obj, bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map('n', '<Leader>x', plugin_obj.some_action)
end

-- In lua/es/plugins/plugin.lua
opts = {
  on_attach = function(bufnr)
    local keymaps = require('es.keymaps')
    keymaps.setup_plugin_keymaps(require('plugin'), bufnr)
  end
}
```

### Adding Plugins

Create a new file in `lua/es/plugins/` or add to an existing one:

```lua
-- lua/es/plugins/mynewplugin.lua
return {
  'author/plugin-name',
  event = 'VeryLazy',  -- or other lazy-loading trigger
  config = function()
    require('plugin-name').setup({
      -- config here
    })
  end,
}
```

Keymaps for the plugin should go in `keymaps.lua`, not in the plugin file.

### Modifying Options

- **Neovim-specific options**: Edit `lua/es/options.lua`
- **Shared Vim/Neovim options**: Edit `.vim/common.vim`

### Python Environment

The Python path in `lua/es/globals.lua` must point to a venv with:
- `debugpy>=1.8.17` (for DAP)
- `pynvim>=0.6.0` (for Neovim Python support)

Update the path if the venv location changes:
```lua
vim.g.python_host_path = vim.fn.expand("~/path/to/venv/bin/python")
```

### Tree-sitter Issues

If parsers fail to install:
1. Ensure `tree-sitter-cli` is installed globally: `npm install -g tree-sitter-cli`
2. Ensure `clang` or `gcc` is available for compilation
3. Check `:TSInstallInfo` for status
4. The config uses `prefer_git = true` which downloads pre-built binaries

### Testing Changes

Use `<Leader><Leader>x` (defined in `globals.lua`) to quickly save and reload the current Lua config file without restarting Neovim.

## Important Files

- **`lua/es/globals.lua`**: Global utilities, Python host path, Lua compatibility fixes
- **`lua/es/keymaps.lua`**: Single source of truth for ALL keymaps
- **`lua/es/plugins/lsp.lua`**: LSP server configuration and Mason setup
- **`lua/es/plugins/dap.lua`**: Debugger configuration for multiple languages
- **`.vim/common.vim`**: Settings shared between Vim and Neovim

## Common Tasks

### Update Plugin Path References

When moving from `~/.config/nvim` to this dotfiles repo, ensure absolute paths in `globals.lua` are updated:
```lua
vim.g.python_host_path = vim.fn.expand("~/dev/repos/dotfiles/.venv/bin/python")
```

### Add LSP Server

1. Add server name to `servers` table in `lua/es/plugins/lsp.lua`
2. Create `lsp/<server_name>.lua` with server-specific settings (or empty `return {}` to use defaults)
3. Mason will auto-install the server on next Neovim launch
4. The server will be enabled automatically via `vim.lsp.enable()`

Example for a new server with custom settings:
```lua
-- lsp/my_server.lua
return {
  settings = {
    myServer = {
      someOption = true,
    },
  },
}
```

Example for a server using defaults:
```lua
-- lsp/my_server.lua
return {}
```

### Add DAP Adapter

1. Add adapter config to `adapters` table in `lua/es/plugins/dap.lua`
2. Add configuration in `configurations` for the filetype
3. Mason-nvim-dap will auto-install the adapter binary

### Change Theme

Edit `lua/es/plugins/ui.lua` and modify the `tokyonight.nvim` configuration or switch to a different theme plugin.

## Dependencies

### Required
- **Neovim 0.10+** (tested with 0.11.5)
  - Uses modern Lua APIs: `vim.uv` (aliased with fallback to `vim.loop` for compatibility)
  - Requires Tree-sitter folding support (`foldmethod=expr`)
  - Requires updated LSP and diagnostic APIs
- Node.js + npm (for `tree-sitter-cli` and `neovim` package)
- Git

### Recommended
- `ripgrep` (rg) - Telescope text search
- `fd` - Telescope file finding
- Python 3.13 with venv containing `debugpy` and `pynvim`

### Language-Specific
Install runtimes as needed: Go, Rust, Python, Node.js, etc.

## Deployment

This repository contains the source dotfiles. Deploy to home directory:
```bash
# Symlink or copy:
ln -s ~/dev/repos/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dev/repos/dotfiles/.vim ~/.vim
ln -s ~/dev/repos/dotfiles/.vimrc ~/.vimrc
ln -s ~/dev/repos/dotfiles/.tmux.conf ~/.tmux.conf
```

First launch will trigger Mason and Tree-sitter auto-installation.
