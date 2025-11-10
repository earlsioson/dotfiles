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
    - [Core workflow](#core-workflow)
    - [Navigation & search](#navigation--search)
    - [LSP](#lsp)
    - [Git](#git)
    - [Debugging](#debugging)
    - [Copilot & completion](#copilot--completion)

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
  The CLI is only strictly required for `:TSInstallFromGrammar`, but having it satisfies `:checkhealth` and lets you generate/inspect parsers locally.

### Python support for Neovim/DAP
Use your preferred python package manager to create a virtualenv and install debugpy and pynvim.
Update `~/.vimrc` and `.config/nvim/after/plugin/dap.lua` so both editors point at the virtualenv’s Python interpreter. That keeps DAP, LSP assistants, and the Python host in sync.

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
| UI | `nvim-tree/nvim-web-devicons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `stevearc/dressing.nvim`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `ellisonleao/glow.nvim`, `stevearc/oil.nvim` |
| Productivity | `zbirenbaum/copilot.lua`, `zbirenbaum/copilot-cmp`, `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim` |
| Language Extras | `nordtheme/vim`, `dracula/vim`, `fatih/vim-go`, `terrastruct/d2-vim` |

> Classic Vim still loads `github/copilot.vim` + `airblade/vim-gitgutter`; Neovim uses the Lua-native Copilot/cmp stack and gitsigns.

### Keymaps
Keymaps assume `<Space>` as the leader key unless noted.

#### Core workflow
| Shortcut | Action |
| --- | --- |
| `<Space>` | Leader key |
| `\` | Leader key for Visual Multi |
| `<Leader>y` | Yank to the system clipboard (normal/visual) |
| `<Leader>n` | New split |
| `<Leader>t` | New tab |
| `<Leader>a` | Alternate buffer |
| `<Leader>cd` | Set local cwd |
| `<Leader>g` | Run `:G | only` |
| `<Leader>s` (visual) | Search selection for quick change |
| `<Leader>k` | Clear last search highlight |
| `<M-.>`, `<M-,>`, `<M-'>`, `<M-;>` | Resize windows |
| `<C-d>`, `<C-u>` | Recenter while paging |
| `<Leader><Leader>t` | Open bottom terminal helper |
| `<Leader><Esc>` | Exit terminal-mode |
| `<Leader><Leader>x` | Write and reload current Lua file |

#### Navigation & search
##### Telescope Pickers

| Shortcut | Action |
| --- | --- |
| `<Leader>ff` | Find files |
| `<Leader>fh` | Find hidden files |
| `<Leader><Leader>ff` | Prompt for directory before listing files |
| `<Leader>fg` | Find git-tracked files |
| `<Leader>fb` | List buffers |
| `<Leader>fo` | Show recently opened files |
| `<Leader>fk` | Show keymaps |

##### Telescope Search & Symbols

| Shortcut | Action |
| --- | --- |
| `<Leader>fs` | Grep word under cursor |
| `<Leader>rg` | Live grep |
| `<Leader><Leader>rg` | Prompt for directories before live grep |
| `<Leader>fd` | Document symbols |
| `<Leader>fw` | Workspace symbols |

##### Telescope File Browser

| Shortcut | Action |
| --- | --- |
| `<Leader>fe` | Respect `.gitignore` |
| `<Leader><Leader>fe` | Ignore `.gitignore` |

##### File Explorers

| Shortcut | Action |
| --- | --- |
| `<Leader>nt` | Toggle NvimTree |
| `<Leader>nf` | Reveal current file in NvimTree |
| `<Leader>no` | Prompt for directory in NvimTree |
| `<Leader>nc` | Close NvimTree |
| `<M-i>` | Open info popup inside NvimTree |
| `-` | Open parent directory in oil |

##### Misc

| Shortcut | Action |
| --- | --- |
| `<Leader>x` | Treesitter context jump |
| `<Leader>mp` | Glow preview |

#### LSP
##### Diagnostics

| Shortcut | Action |
| --- | --- |
| `<Leader>do` | Show diagnostics float |
| `<Leader>dl` | Populate location list with diagnostics |
| `<Leader>ds` | Show diagnostics |
| `<Leader>dh` | Hide diagnostics |

##### Buffer-local (attached)

| Shortcut | Action |
| --- | --- |
| `<Leader>lD` | Go to declaration |
| `<Leader>ld` | Go to definition |
| `<Leader>lh` | Hover |
| `<Leader>li` | Go to implementation |
| `<Leader>ls` | Signature help |
| `<Leader>lf` | Format buffer |
| `<Leader>lw` | Add workspace folder |
| `<Leader>lW` | Remove workspace folder |
| `<Leader>ll` | List workspace folders |
| `<Leader>lt` | Go to type definition |
| `<Leader>ln` | Rename symbol |
| `<Leader>la` | Code action |
| `<Leader>lA` | TypeScript source action |
| `<Leader>lr` | References |
| `<Leader>=` | Async format |
| `<Leader>lI` | Toggle inlay hints |

#### Git
| Shortcut | Action |
| --- | --- |
| `[c` / `]c` | Hunk navigation (gitsigns) |
| `<Leader>hs` | Stage hunk |
| `<Leader>hr` | Reset hunk |
| `<Leader>hS` | Stage buffer |
| `<Leader>hu` | Undo stage |
| `<Leader>hR` | Reset buffer |
| `<Leader>hp` | Preview hunk |
| `<Leader>hb` | Blame line |
| `<Leader>tb` | Toggle blame |
| `<Leader>hd` | Diff against index |
| `<Leader>hD` | Diff against `~` |
| `<Leader>td` | Toggle deleted |
| `ih` | Hunk text object |

#### Debugging
##### Core

| Shortcut | Action |
| --- | --- |
| `<Leader>bv` | Load launch config |
| `<Leader>bc` | Continue |
| `<Leader>bo` | Step over |
| `<Leader>bI` | Step into |
| `<Leader>bO` | Step out |
| `<Leader>bb` | Toggle breakpoint |
| `<Leader>bt` | Terminate session |
| `<Leader><Leader>bb` | Clear breakpoints |

##### Extras

| Shortcut | Action |
| --- | --- |
| `<Leader>be` | Configure exception breakpoints |
| `<Leader>bB` | Conditional breakpoint |
| `<Leader>bL` | Logpoint |
| `<Leader>br` | Open REPL |
| `<Leader>bl` | Run last debugging configuration |
| `<Leader>bw` | Manage watches |
| `<Leader>bh` | Hover variables |
| `<Leader>bp` | Preview variables |
| `<Leader>bf` | Show frames |
| `<Leader>bs` | Show scopes |
| `<Leader>bu` | Toggle UI |

#### Copilot & completion
Neovim routes Copilot suggestions through `copilot.lua` + `copilot-cmp` (so `<C-l>` triggers a normal `cmp.confirm`). Vim keeps the Vimscript `github/copilot.vim` backend, but the keymaps match.

##### Copilot

| Shortcut | Action |
| --- | --- |
| `<C-l>` | Accept suggestion / confirm completion |
| `<Leader>ce` | Enable Copilot |
| `<Leader>cd` | Disable Copilot |

##### nvim-cmp

| Shortcut | Action |
| --- | --- |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Cycle items / move through snippets |
