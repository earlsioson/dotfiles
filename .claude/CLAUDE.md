# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a personal dotfiles repository containing configuration for Neovim, Vim, tmux, and CLI tools. The primary focus is a modern Neovim setup with comprehensive LSP, debugging, and AI assistance capabilities.

## Neovim Architecture

### Configuration Structure

```
.config/nvim/
├── init.lua                 # Entry point: loads modules in sequence
├── lua/es/
│   ├── globals.lua         # Global utilities, Python paths, Lua compatibility
│   ├── lazy.lua            # lazy.nvim plugin manager bootstrap
│   ├── options.lua         # Editor options (folding, clipboard, tmux integration)
│   ├── keymaps.lua         # ALL keymaps centralized here (221 lines)
│   ├── autocmds.lua        # Autocommands
│   ├── ui.lua              # UI configuration
│   └── plugins/            # Plugin configs (auto-loaded by lazy.nvim)
│       ├── lsp.lua         # Mason + LSP configuration
│       ├── telescope.lua   # Fuzzy finder + extensions
│       ├── treesitter.lua  # Syntax parsing
│       ├── cmp.lua         # Completion engine
│       ├── dap.lua         # Debug Adapter Protocol
│       ├── git.lua         # gitsigns
│       └── ...
```

### Key Architectural Principles

1. **Centralized Keymaps**: ALL keymaps live in `lua/es/keymaps.lua` (not scattered in plugin files). This makes discovery and learning easier.

2. **Modular Plugin Loading**: Each file in `lua/es/plugins/*.lua` returns a lazy.nvim plugin spec. The plugin manager auto-discovers and loads them.

3. **Namespace Organization**:
   - `<Leader>c*` = Code operations (LSP)
   - `<Leader>d*` = Debug operations (DAP)
   - `<Leader>f*` = Find operations (Telescope)
   - `<Leader>g*` = Git operations
   - `<Leader>n*` = NvimTree
   - `<Leader>x*` = Diagnostics

4. **Shared Vim/Neovim Config**: `.vim/common.vim` contains settings used by both classic Vim and Neovim to avoid duplication.

5. **Python Path Centralization**: Python host path is defined once in `globals.lua` (`vim.g.python_host_path`) and reused by both the Neovim provider and DAP configurations.

6. **Lua Compatibility**: `globals.lua` sets `_G.unpack = _G.unpack or table.unpack` to handle Lua 5.1/LuaJIT vs Lua 5.2+ differences globally.

7. **Neovim API Compatibility**: The config targets Neovim 0.10+ and uses modern APIs:
   - `vim.uv` for async operations (with `vim.loop` fallback for 0.9 compatibility)
   - Modern LSP setup patterns
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

- **Servers**: Managed via Mason and auto-installed: `cssls`, `dockerls`, `gopls`, `html`, `jsonls`, `lua_ls`, `oxlint`, `pyright`, `ruff`, `rust_analyzer`, `tailwindcss`, `terraformls`, `ts_ls`, `vimls`, `yamlls`
- **Setup**: `lua/es/plugins/lsp.lua` configures Mason, mason-lspconfig, and nvim-lspconfig
- **Keymaps**: LSP keymaps are in `keymaps.lua` under `<Leader>c*` namespace

### DAP (Debugger) Configuration

- **Adapters**: Python (`debugpy`), Go (`delve`), C/C++/Rust (`codelldb`), JS/TS (`js-debug-adapter`)
- **Setup**: `lua/es/plugins/dap.lua` with mason-nvim-dap for auto-installation
- **Python**: Uses the venv defined in `globals.lua`
- **Keymaps**: Debug keymaps under `<Leader>d*` namespace

### Tree-sitter Configuration

- Uses `prefer_git = true` to download pre-built parsers (more reliable than compiling)
- Auto-installs on first Neovim launch
- Folding configured via Tree-sitter expressions in `options.lua`

## Making Changes

### Adding/Modifying Keymaps

**DO**: Edit `lua/es/keymaps.lua` to add or change keymaps.
**DON'T**: Add keymaps inside plugin configuration files.

Example:
```lua
-- In lua/es/keymaps.lua
vim.keymap.set('n', '<Leader>cx', '<cmd>SomeCommand<cr>', { desc = 'Code: Some action' })
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
2. Mason will auto-install it on next Neovim launch
3. Add language-specific keymaps to `lua/es/keymaps.lua` if needed

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
