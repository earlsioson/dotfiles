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
> The configuration follows modern Neovim 0.10+ idioms with proper lazy loading, uses `vim.uv` for async operations, and centralizes settings for maintainability.

### Keymaps
All Neovim keymaps are centralized in `.config/nvim/lua/es/keymaps.lua`. Shared vim/neovim keymaps live in `.vim/common.vim`. Leader key is `<Space>`.

The keymap system follows a consistent mnemonic namespace:
- **Vim conventions** (1-key, no leader): Standard vim/LSP mappings like `gd`, `K`, `]d`, `[d`
- **`<Leader>c*`** = "code" operations (LSP actions)
- **`<Leader>d*`** = "debug" operations (DAP debugger)
- **`<Leader>f*`** = "find" operations (Telescope with ripgrep/fd)
- **`<Leader>g*`** = "git" operations (fugitive + gitsigns)
- **`<Leader>n*`** = "nvimtree" operations (file tree navigation)
- **`<Leader>x*`** = diagnostics ("fix" operations)

#### Vim conventions (no leader)
| Shortcut | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `]d` / `[d` | Next/previous diagnostic |
| `]c` / `[c` | Next/previous git hunk |

#### Code operations (`<Leader>c*`)
LSP actions for modifying, analyzing, and navigating code.

| Shortcut | Action |
| --- | --- |
| `<Leader>ca` | Code action |
| `<Leader>cr` | Code rename |
| `<Leader>cf` | Code format |
| `<Leader>cs` | Code signature help |
| `<Leader>ct` | Code type definition |
| `<Leader>ci` | Code inlay hints (toggle) |
| `<Leader>cx` | Code context jump (treesitter) |
| `<Leader>cT` | Copilot toggle |

#### Debug operations (`<Leader>d*`)
DAP debugger controls and inspection.

| Shortcut | Action |
| --- | --- |
| `<Leader>dc` | Debug continue |
| `<Leader>db` | Debug breakpoint (toggle) |
| `<Leader>dB` | Debug breakpoint (conditional) |
| `<Leader>ds` | Debug step over |
| `<Leader>di` | Debug step into |
| `<Leader>do` | Debug step out |
| `<Leader>dt` | Debug terminate |
| `<Leader>dr` | Debug REPL |
| `<Leader>du` | Debug UI (toggle) |
| `<Leader>dv` | Debug load vscode config |
| `<Leader>dl` | Debug run last |
| `<Leader>dk` | Debug kill all breakpoints |
| `<Leader>dh` | Debug hover variables |
| `<Leader>dw` | Debug watches |
| `<Leader>df` | Debug frames |
| `<Leader>dp` | Debug preview scopes |

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
Git operations via fugitive and gitsigns.

| Shortcut | Action |
| --- | --- |
| `<Leader>gg` | Git status |
| `<Leader>gs` | Git stage hunk |
| `<Leader>gr` | Git reset hunk |
| `<Leader>gS` | Git stage buffer |
| `<Leader>gR` | Git reset buffer |
| `<Leader>gu` | Git undo stage |
| `<Leader>gp` | Git preview hunk |
| `<Leader>gb` | Git blame line |
| `<Leader>gt` | Git toggle blame |
| `<Leader>gx` | Git toggle deleted |
| `<Leader>gd` | Git diff |
| `<Leader>gD` | Git diff against `~` |
| `ih` (text object) | Git hunk text object |

#### NvimTree (`<Leader>n*`)
File tree navigation.

| Shortcut | Action |
| --- | --- |
| `<Leader>nt` | NvimTree toggle |
| `<Leader>nf` | NvimTree find file |
| `<Leader>no` | NvimTree open dir |
| `<Leader>nc` | NvimTree close |

#### Diagnostics (`<Leader>x*`)
LSP diagnostic management.

| Shortcut | Action |
| --- | --- |
| `<Leader>xx` | Diagnostic float |
| `<Leader>xl` | Diagnostic loclist |
| `<Leader>xs` | Diagnostic show |
| `<Leader>xh` | Diagnostic hide |

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

#### Shared keymaps (`.vim/common.vim`)
These work in both Vim and Neovim.

| Shortcut | Action |
| --- | --- |
| `<Leader>y` | Yank to system clipboard (normal/visual) |
| `<Leader>n` | New split |
| `<Leader>a` | Alternate buffer |
| `<Leader>s` (visual) | Search selection for quick change |
| `<Leader>k` | Clear last search highlight |
| `<M-.>`, `<M-,>`, `<M-'>`, `<M-;>` | Resize windows |
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
