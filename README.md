# dotfiles

## Overview
Personal configuration for Neovim, Vim, tmux, and assorted CLI tools.

## Table of Contents
- [Quick Start](#quick-start)
  - [Base editor prerequisites](#base-editor-prerequisites)
  - [Tree-sitter + Node.js toolchain](#tree-sitter--nodejs-toolchain)
  - [Python support for Neovim/DAP](#python-support-for-neovimdap)
  - [Plugin bootstrap (lazy.nvim)](#plugin-bootstrap-lazynvim)
  - [Optional tooling](#optional-tooling)
- [tmux Configuration](#tmux-configuration)
  - [Setup](#setup)
  - [tmux Keymaps](#tmux-keymaps)
- [Neovim Configuration](#neovim-configuration)
  - [Plugin stack](#plugin-stack)
  - [Keymaps](#keymaps)
    - [Vim conventions](#vim-conventions-no-leader)
    - [Code operations](#code-operations-leaderc)
    - [Debug operations](#debug-operations-leaderd)
    - [Find operations](#find-operations-leaderf)
    - [Git operations](#git-operations-leaderg)
    - [NvimTree](#nvimtree-leadern)
    - [Diagnostics](#diagnostics-leaderx)
    - [Flash navigation](#flash-navigation)
    - [Other mappings](#other-mappings)
    - [Shared keymaps](#shared-keymaps-vimcommonvim)
    - [nvim-cmp completion](#nvim-cmp-completion)

## Quick Start

### Base editor prerequisites
1. Install current releases of Vim and Neovim.
2. Install a Nerd Font (I usually grab one from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)).
3. Copy `.vim/` into `$HOME/.vim`, `.config/nvim/` into `$HOME/.config/nvim`, and `.vimrc` into `$HOME/.vimrc`.

### Tree-sitter + Node.js toolchain
- Install Node.js so LSP servers and formatters can run under `node`.
- Install the Tree-sitter CLI plus Neovim’s npm helper:
  ```bash
  npm install -g tree-sitter-cli neovim
  tree-sitter --version   # sanity check
  ```

### Python support for Neovim/DAP
Use your preferred python package manager to create a virtualenv and install debugpy and pynvim.
Update the Python path in `.config/nvim/lua/es/globals.lua` (`vim.g.python_host_path`) to point at your virtualenv's Python interpreter. This path is automatically used by `init.lua` and DAP, keeping the Python host and debugger in sync.

### Plugin bootstrap (lazy.nvim)
When launching Neovim you'll see the Mason installer and Tree-sitter setup run automatically.

### Optional tooling
- Telescope pickers expect [`ripgrep`](https://github.com/BurntSushi/ripgrep) and [`fd`](https://github.com/sharkdp/fd) on `$PATH`.
- Language-specific runtimes (Go, Python, etc.) should be installed before launching Mason or DAP adapters.
- Git, tmux, and a POSIX shell are assumed.

## tmux Configuration

### Setup
1. Install [tpm](https://github.com/tmux-plugins/tpm).
2. Copy `.tmux.conf` to `$HOME/.tmux.conf`.
3. Start tmux and press `<prefix>I` (capital i) to install plugins via tpm.

### tmux Keymaps
| Shortcut | Action |
| --- | --- |
| `C-k` (no prefix) | Reset pane display and clear scrollback (`send-keys -R`, `C-l`, `clear-history`). |
| `<prefix>a` | Toggle synchronize-panes for the current window. |
| `M-9` / `M-0` (no prefix) | Swap to previous/next window and focus it. |
| `S-Left` / `S-Right` | Resize pane 10 cells horizontally. |
| `S-Up` / `S-Down` | Resize pane 10 cells vertically. |

## Neovim Configuration

### Plugin stack
| Category | Plugins |
| --- | --- |
| LSP | `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim`, `jay-babu/mason-nvim-dap.nvim` |
| Treesitter | `nvim-treesitter/nvim-treesitter`, `nvim-treesitter/nvim-treesitter-context` |
| Completion | `hrsh7th/nvim-cmp`, `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`, `hrsh7th/cmp-cmdline`, `hrsh7th/cmp-nvim-lua`, `hrsh7th/cmp-nvim-lsp`, `hrsh7th/cmp-nvim-lsp-signature-help`, `saadparwaiz1/cmp_luasnip`, `L3MON4D3/LuaSnip` |
| Debugging | `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `mfussenegger/nvim-dap-python`, `leoluz/nvim-dap-go`, `nvim-neotest/nvim-nio` |
| Telescope | `nvim-telescope/telescope.nvim`, `nvim-telescope/telescope-file-browser.nvim`, `nvim-telescope/telescope-live-grep-args.nvim`, `nvim-telescope/telescope-fzf-native.nvim` |
| UI | `nvim-tree/nvim-web-devicons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `stevearc/dressing.nvim`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `ellisonleao/glow.nvim`, `stevearc/oil.nvim`, `karb94/neoscroll.nvim` |
| Navigation | `folke/flash.nvim` |
| Productivity | `zbirenbaum/copilot.lua`, `zbirenbaum/copilot-cmp`, `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim` |
| Language Extras | `nordtheme/vim`, `dracula/vim`, `fatih/vim-go`, `terrastruct/d2-vim` |

> Classic Vim still loads `github/copilot.vim` + `airblade/vim-gitgutter`; Neovim uses the Lua-native Copilot/cmp stack and gitsigns.
>
> Plugins auto-load from `.config/nvim/lua/es/plugins/*.lua` via lazy.nvim. Tree-sitter uses `prefer_git = true` to download pre-built parsers. Mason auto-installs DAP adapters (`debugpy`, `delve`, `codelldb`, `js-debug-adapter`) on first launch.
>
> The configuration follows modern Neovim 0.11+ idioms with proper lazy loading, uses `vim.uv` for async operations, and centralizes settings for maintainability.

### Keymaps
All Neovim keymaps are centralized in `.config/nvim/lua/es/keymaps.lua`. Buffer-local keymaps (like gitsigns) are defined in keymaps.lua as exported functions and called from plugin on_attach callbacks. Shared vim/neovim keymaps live in `.vim/common.vim`. Leader key is `<Space>`.

The keymap system follows a consistent namespace that mirrors the Neovim API:
- **`<Leader>l*`** = LSP operations (mirrors `vim.lsp.buf.*` API)
- **`<Leader>d*`** = Diagnostic operations (mirrors `vim.diagnostic.*` API, navigation uses `]d`/`[d` defaults)
- **`<Leader>b*`** = Debug/breakpoint operations (DAP)
- **`<Leader>f*`** = Find operations (Telescope with ripgrep/fd)
- **`<Leader>h*`** = Hunk operations (gitsigns, buffer-local in git files)
- **`<Leader>t*`** = Toggle operations (gitsigns)
- **`<Leader>g*`** = Git operations (Fugitive)
- **`<Leader>n*`** = NvimTree operations (file tree navigation)

#### Neovim 0.11 defaults (no leader)
| Shortcut | Action |
| --- | --- |
| `]d` / `[d` | Next/previous diagnostic |
| `]D` / `[D` | First/last diagnostic |

#### LSP operations (`<Leader>l*`)
Keymaps mirror `vim.lsp.buf.*` API methods for easy memorization.

| Shortcut | Action |
| --- | --- |
| `<Leader>la` | Code action |
| `<Leader>lc` | Incoming calls |
| `<Leader>lC` | Outgoing calls |
| `<Leader>ld` | Definition |
| `<Leader>lD` | Declaration |
| `<Leader>lf` | Format |
| `<Leader>lh` | Hover |
| `<Leader>li` | Implementation |
| `<Leader>lo` | Document outline (symbols) |
| `<Leader>lr` | References |
| `<Leader>ln` | Rename |
| `<Leader>ls` | Signature help |
| `<Leader>lt` | Type definition |
| `<Leader>lw` | Workspace symbols |

#### Diagnostic operations (`<Leader>d*`)
Keymaps mirror `vim.diagnostic.*` API methods. Navigation uses `]d`/`[d` defaults above.

| Shortcut | Action |
| --- | --- |
| `<Leader>df` | Diagnostic float |
| `<Leader>dl` | Diagnostic loclist |
| `<Leader>dq` | Diagnostic quickfix |

#### Debug operations (`<Leader>b*`)
DAP debugger controls and inspection.

| Shortcut | Action |
| --- | --- |
| `<Leader>bc` | Continue |
| `<Leader>bb` | Breakpoint (toggle) |
| `<Leader>bB` | Breakpoint (conditional) |
| `<Leader>bs` | Step over |
| `<Leader>bi` | Step into |
| `<Leader>bo` | Step out |
| `<Leader>bt` | Terminate |
| `<Leader>br` | REPL |
| `<Leader>bu` | UI (toggle) |
| `<Leader>bv` | Load vscode config |
| `<Leader>bl` | Run last |
| `<Leader>bk` | Kill all breakpoints |
| `<Leader>bh` | Hover variables |
| `<Leader>bw` | Watches |
| `<Leader>bf` | Frames |
| `<Leader>bp` | Preview scopes |

#### Find operations (`<Leader>f*`)
Telescope pickers using ripgrep for text search and fd for file finding.

| Shortcut | Action |
| --- | --- |
| `<Leader>ff` | Find files |
| `<Leader>fr` | Find with ripgrep (live grep) |
| `<Leader>fb` | Find buffers |
| `<Leader>fg` | Find git files |
| `<Leader>fo` | Find oldfiles (recent) |
| `<Leader>fh` | Find hidden files |
| `<Leader>fw` | Find workspace symbols |
| `<Leader>fd` | Find document symbols |
| `<Leader>fk` | Find keymaps |
| `<Leader>fe` | Find explorer (file browser) |
| `<Leader>fE` | Find explorer all (no gitignore) |

#### Git operations (`<Leader>g*`)
Fugitive operations.

| Shortcut | Action |
| --- | --- |
| `<Leader>gg` | Git status |

#### Hunk operations (`<Leader>h*` and `<Leader>t*`)
Gitsigns operations (buffer-local, only in git files).

| Shortcut | Action |
| --- | --- |
| `]c` / `[c` | Next/previous hunk |
| `<Leader>hs` | Stage hunk |
| `<Leader>hr` | Reset hunk |
| `<Leader>hS` | Stage buffer |
| `<Leader>hR` | Reset buffer |
| `<Leader>hu` | Undo stage |
| `<Leader>hp` | Preview hunk |
| `<Leader>hi` | Preview hunk inline |
| `<Leader>hb` | Blame line |
| `<Leader>hd` | Diff |
| `<Leader>hD` | Diff against `~` |
| `<Leader>hq` / `<Leader>hQ` | Hunks to quickfix (current/all) |
| `<Leader>tb` | Toggle blame |
| `<Leader>tw` | Toggle word diff |
| `ih` (text object) | Hunk text object |

#### NvimTree (`<Leader>n*`)
File tree navigation.

| Shortcut | Action |
| --- | --- |
| `<Leader>nt` | NvimTree toggle |
| `<Leader>nf` | NvimTree find file |
| `<Leader>no` | NvimTree open dir |
| `<Leader>nc` | NvimTree close |
| `<Leader>np` | NvimTree open parent directory |


#### Flash navigation
Quick jump navigation (preserves vim defaults for `s`/`S`).

| Shortcut | Action |
| --- | --- |
| `<Leader>s` | Flash jump |
| `<Leader>S` | Flash treesitter |
| `r` (operator pending) | Flash remote |
| `R` (operator/visual) | Flash treesitter search |
| `<C-s>` (command mode) | Flash toggle search |

#### Other mappings
| Shortcut | Action |
| --- | --- |
| `-` | Oil parent directory |
| `<Leader>mp` | Markdown preview |
| `<Leader>ct` | Copilot toggle |

#### Shared keymaps (`.vim/common.vim`)
These work in both Vim and Neovim.

| Shortcut | Action |
| --- | --- |
| `<Leader>y` | Yank to system clipboard (normal/visual) |
| `<Leader>n` | New split |
| `<Leader>a` | Alternate buffer |
| `<Leader>r` (visual) | Search selection for quick replace |
| `<Leader>k` | Clear last search highlight |
| `<M-.>`, `<M-,>`, `<M-'>`, `<M-;>` | Resize windows |
| `z0` | Set foldlevel to 99 (show all folds) |
| `z1` - `z6` | Set foldlevel 1-6 (useful for Markdown heading hierarchy) |
| `<Leader><Leader>t` | Open bottom terminal helper |
| `<Leader><Esc>` | Exit terminal-mode |

#### nvim-cmp completion
| Shortcut | Action |
| --- | --- |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Cycle items / move through snippets |
