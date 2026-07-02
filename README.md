# dotfiles

## Overview
Personal configuration for Neovim, Vim, tmux, and assorted CLI tools.

## Philosophy
This repo is default-first. Vim and Neovim start from their native behavior, adding only the preferences and workflow shortcuts worth carrying between machines.

The configurations follow each tool's idioms:
- **Vim**: Uses Vimscript, `defaults.vim`, and native packages under `~/.vim/pack`.
- **Neovim**: Uses Lua, `vim.pack` package management, built-in LSP defaults, and lazy-loaded feature modules.
- **Shared Behavior**: Defined in [common.vim](file:///Users/developer/dev/repos/dotfiles/.vim/common.vim). Neovim-only additions live in [keymaps.lua](file:///Users/developer/dev/repos/dotfiles/.config/nvim/lua/es/keymaps.lua).

## Configuration Layout
The repository contains the following configurations mapping to standard paths in `$HOME`:

* **`[common.vim](file:///Users/developer/dev/repos/dotfiles/.vim/common.vim)`** -> Shared settings (indentation, line numbers, search defaults, and core keymaps).
* **`[.vimrc](file:///Users/developer/dev/repos/dotfiles/.vimrc)`** -> Vim baseline configuration.
* **`[.vim/](file:///Users/developer/dev/repos/dotfiles/.vim)`** -> Vim native packages and runtime files.
* **`[.config/nvim/](file:///Users/developer/dev/repos/dotfiles/.config/nvim)`** -> Neovim Lua environment (`init.lua`, package specs, options, and plugin setups).
* **`[.tmux.conf](file:///Users/developer/dev/repos/dotfiles/.tmux.conf)`** -> tmux configuration (prefix set to `<C-Space>`, options, and TPM plugins).
* **`[.cargo/config](file:///Users/developer/dev/repos/dotfiles/.cargo/config)`** -> Cargo options.
* **`[.config/starship.toml](file:///Users/developer/dev/repos/dotfiles/.config/starship.toml)`** -> Starship prompt layout and modules.

---

## Dependencies & Prerequisites

### System Requirements
* Current releases of **Vim**, **Neovim** (>= 0.11.2), **Git**, **`just`**, **tmux**, and a POSIX shell.
* A **Nerd Font** (recommended for rendering Neovim UI icons).

### Language Toolchains & Runtimes
* **Node.js**: Required backend runtime for LSP servers and formatters.
* **Tree-sitter CLI & Neovim npm helper**: Required for parser compilation.
  * System packages: `tree-sitter-cli`, `neovim` (installed globally via `npm install -g`).
* **Python virtualenv**: Used for Neovim host and DAP support.
  * Required virtualenv packages: `pynvim`, `debugpy`.
  * Configuration: The path to this virtualenv's Python binary must be set in `es/globals.lua` (`vim.g.python_host_path`).
* **Language-specific runtimes** (Go, Python, etc.) must be present on `$PATH` before configuring corresponding LSP servers or debug adapters.

---

## Package & Plugin Management

### Vim Package Management
Vim uses native packages located in:
```text
~/.vim/pack/plugins/start/{plugin}
```
The repository [justfile](file:///Users/developer/dev/repos/dotfiles/justfile) defines targets to manage these folders:
* `just vim-plugins-install`: Clones missing Vim package repositories.
* `just vim-plugins-update`: Pulls latest changes (`git pull --ff-only`) for all existing Vim packages.
* `just vim-go-binaries`: Runs `:GoUpdateBinaries` to compile Vim-go dependencies.
* **Installation Root**: Default is `~/.vim/pack/plugins`. Can be overridden with the `VIM_PACK_ROOT` environment variable.

### Neovim Plugin Management
Neovim uses the native `vim.pack` package mechanism defined in `es/pack.lua`. On launch, missing plugins are installed automatically to Neovim's package directories, generating `~/.config/nvim/nvim-pack-lock.json`.

**LSP & Plugin Commands:**
* `:PackStatus`: Inspect installed package states.
* `:PackUpdate`: Update package versions.
* `:Mason`: Open the Mason package manager interface.
* `:LspBootstrap`: Bootstrap Mason LSP server installations.
* `:LspInfo`: Show active LSP clients and config status.
* `:TSUpdate`: Compile/update Tree-sitter parsers.

---

## Active Paths & State Reset
For reference during backups or troubleshooting, the configuration and generated state directories are located in these standard paths:

| Component | Configuration Source | Generated State / Cache (Safe to clear) |
| --- | --- | --- |
| **Vim** | `~/.vim`, `~/.vimrc` | None (Vim uses native packages) |
| **Neovim** | `~/.config/nvim` | `~/.local/share/nvim` (plugins/data)<br>`~/.local/state/nvim` (logs/undo)<br>`~/.cache/nvim` (caches) |
| **tmux** | `~/.tmux.conf` | `~/.tmux/plugins` (TPM checkouts) |
| **Cargo** | `~/.cargo/config` | None |
| **Starship** | `~/.config/starship.toml` | None |

---

## tmux Configuration
* **TPM Plugin Manager**: Manages plugin life cycle via [tpm](https://github.com/tmux-plugins/tpm).
* **Prefix Key**: Configured to `Ctrl-Space` (`C-Space`).

### tmux Keymaps

| Shortcut | Action |
| --- | --- |
| `C-k` (no prefix) | Reset pane display and clear scrollback (`send-keys -R`, `C-l`, `clear-history`) |
| `<prefix>a` | Toggle synchronize-panes for current window |
| `M-9` / `M-0` (no prefix) | Swap to previous/next window and focus it |
| `S-Left` / `S-Right` | Resize pane 10 cells horizontally |
| `S-Up` / `S-Down` | Resize pane 10 cells vertically |

---

## Vim Configuration
* **Vim Baseline**: Sourced closely from `defaults.vim`. No named colorscheme is configured; `set background=dark` leverages the terminal or tmux color palette.
* **Vim-Specific Plugins**:
  * `tpope/vim-surround`
  * `tpope/vim-unimpaired`
  * `tpope/vim-fugitive`
  * `airblade/vim-gitgutter`
  * `fatih/vim-go`
  * `github/copilot.vim` (Vim-only, Neovim uses native Copilot LSP)
  * `terrastruct/d2-vim`

### Package Inspection Commands
* `:scriptnames`: List all sourced scripts.
* `:set runtimepath?`: View active runtime path.
* `:set packpath?`: View package search path.

---

## Neovim Configuration

### Plugin Stack

| Category | Plugins |
| --- | --- |
| **Formatting** | `stevearc/conform.nvim` |
| **LSP** | `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim`, `jay-babu/mason-nvim-dap.nvim` |
| **Treesitter** | `nvim-treesitter/nvim-treesitter`, `nvim-treesitter/nvim-treesitter-context` |
| **Completion** | `hrsh7th/nvim-cmp`, `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`, `hrsh7th/cmp-cmdline`, `hrsh7th/cmp-nvim-lsp` |
| **Debugging** | `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `mfussenegger/nvim-dap-python`, `leoluz/nvim-dap-go`, `nvim-neotest/nvim-nio` |
| **Telescope** | `nvim-telescope/telescope.nvim`, `nvim-telescope/telescope-file-browser.nvim`, `nvim-telescope/telescope-live-grep-args.nvim`, `nvim-telescope/telescope-fzf-native.nvim` |
| **UI** | `echasnovski/mini.icons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `ellisonleao/glow.nvim`, `stevearc/oil.nvim`, `karb94/neoscroll.nvim` |
| **Navigation** | `folke/flash.nvim` |
| **Productivity** | `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim`, `folke/sidekick.nvim` |
| **Language Extras** | `fatih/vim-go`, `terrastruct/d2-vim` |

### Sidekick & Copilot LSP Configuration
Next Edit Suggestions (NES) use the `copilot` LSP client configuration.
* **LSP Integration**: Initialized via `vim.lsp.enable("copilot")`. The underlying Mason server package name is `copilot-language-server`.
* **Authentication**: Signs in using the `:LspCopilotSignIn` command via the GitHub device verification flow.
* **Persistence**: AI CLI sessions automatically hook into `tmux` persistence to stay alive when Neovim restarts.

**Usage Mappings:**
* **Auto-Trigger**: Pausing, typing, or leaving insert mode prompts automatic suggestions.
* **`<Tab>`**: Applies active edit suggestion (falls back to native inline completion or standard tab).
* **`:Sidekick nes update`**: Manually requests a suggestion at the cursor.
* **`:Sidekick nes toggle`**: Disables or re-enables Next Edit Suggestions.

### Keymaps Reference
Detailed Vim and Neovim keymaps are documented in:
* **[docs/keymaps.md](file:///Users/developer/dev/repos/dotfiles/docs/keymaps.md)** (Full reference manual)
* **[common.vim](file:///Users/developer/dev/repos/dotfiles/.vim/common.vim)** (Shared Vim/Neovim mappings)
* **[keymaps.lua](file:///Users/developer/dev/repos/dotfiles/.config/nvim/lua/es/keymaps.lua)** (Neovim-only mappings)
