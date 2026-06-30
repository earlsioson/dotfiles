# dotfiles

## Overview
Personal configuration for Neovim, Vim, tmux, and assorted CLI tools.

## Philosophy
This repo is default-first. Vim and Neovim should start from their current native behavior, then add only the preferences and workflow shortcuts that are worth carrying between machines.

The editor configs intentionally follow each tool's own idioms:
- Vim uses Vimscript, `defaults.vim`, and native packages under `~/.vim/pack`.
- Neovim uses Lua, `vim.pack`, built-in LSP defaults, and small feature modules.
- Shared behavior lives in `.vim/common.vim`; tool-specific behavior stays in `.vimrc` or `.config/nvim/`.

Generated runtime state does not belong in this repo. Plugin checkouts, caches, Neovim package locks, Mason installs, and local tool state are recreated in `$HOME`.

## Table of Contents
- [Philosophy](#philosophy)
- [Quick Start](#quick-start)
  - [Base editor prerequisites](#base-editor-prerequisites)
  - [Tree-sitter + Node.js toolchain](#tree-sitter--nodejs-toolchain)
  - [Python support for Neovim/DAP](#python-support-for-neovimdap)
  - [Plugin management](#plugin-management)
  - [Reset and reinstall](#reset-and-reinstall)
  - [Optional tooling](#optional-tooling)
- [tmux Configuration](#tmux-configuration)
  - [Setup](#setup)
  - [tmux Keymaps](#tmux-keymaps)
- [Vim Configuration](#vim-configuration)
  - [Vim baseline](#vim-baseline)
  - [Vim package commands](#vim-package-commands)
  - [Vim package inspection](#vim-package-inspection)
- [Neovim Configuration](#neovim-configuration)
  - [Plugin stack](#plugin-stack)
  - [Sidekick NES](#sidekick-nes)
  - [Keymaps](#keymaps)

## Quick Start

### Base editor prerequisites
1. Install current releases of Vim and Neovim.
2. Install `just`, Git, tmux, and a POSIX shell.
3. Install a Nerd Font if you want the Neovim UI icons to render cleanly.
4. Sync the tracked runtime files from this repo into `$HOME`, including:
   - `.vim/` -> `~/.vim`
   - `.vimrc` -> `~/.vimrc`
   - `.config/nvim/` -> `~/.config/nvim`
   - `.tmux.conf` -> `~/.tmux.conf`
   - `.cargo/config` -> `~/.cargo/config`
   - `.config/starship.toml` -> `~/.config/starship.toml`

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

### Plugin management
Vim and Neovim both use native package mechanisms, but they install differently.

Vim loads native packages from `~/.vim/pack/plugins/start`. Vim does not clone or update Git repositories, so the repo `justfile` handles that external step:

```bash
just vim-plugins-install
just vim-plugins-update
just vim-go-binaries
```

Set `VIM_PACK_ROOT` to install somewhere other than `~/.vim/pack/plugins`.

Neovim 0.12 manages plugins with `vim.pack` from `.config/nvim/lua/es/pack.lua`. On first launch, `vim.pack` installs plugins into Neovim's managed package directory and creates `~/.config/nvim/nvim-pack-lock.json`.
Useful commands after startup:

```vim
:PackStatus
:PackUpdate
:Mason
:LspBootstrap
:LspInfo
:TSUpdate
```

Run `:LspBootstrap` on a fresh machine to load the lazy LSP feature and install the configured Mason LSP dependencies. Normal editing loads LSP automatically when a file is opened or created.

### Reset and reinstall
If you want to wipe the tracked editor/shell config plus local runtime state under `$HOME` and reinstall from this repo:

1. Back up or remove the current config and runtime data.

```bash
mkdir -p ~/dotfiles-backup
mv ~/.vim ~/.vimrc ~/.config/vim ~/.tmux.conf ~/.cargo/config ~/.config/starship.toml \
  ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/dotfiles-backup/ 2>/dev/null
mv ~/.config/nvim ~/dotfiles-backup/ 2>/dev/null
```

For Vim-only cleanup, the relevant paths are:

```text
~/.vim
~/.vimrc
~/.config/vim
```

Vim does not use Neovim's `~/.local/share/nvim`, `~/.local/state/nvim`, or `~/.cache/nvim` paths.

2. If you prefer deletion instead of backup for generated editor runtime state:

```bash
rm -rf ~/.vim ~/.vimrc ~/.config/vim
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

3. Reinstall the tracked config from this repo.

```bash
REPO_DIR=~/src/dotfiles
mkdir -p ~/.config ~/.cargo
cp -R "$REPO_DIR/.vim" ~/.vim
cp "$REPO_DIR/.vimrc" ~/.vimrc
cp -R "$REPO_DIR/.config/nvim" ~/.config/nvim
cp "$REPO_DIR/.tmux.conf" ~/.tmux.conf
cp "$REPO_DIR/.cargo/config" ~/.cargo/config
cp "$REPO_DIR/.config/starship.toml" ~/.config/starship.toml
```

If you sync with `rsync --delete`, exclude Neovim's native package lockfile so the runtime package state is not reset on every sync:

```bash
rsync -av --delete \
  --exclude nvim-pack-lock.json \
  "$REPO_DIR/.config/nvim/" ~/.config/nvim/
```

4. Install Vim packages and start Neovim once so `vim.pack` can install Neovim plugins.

```bash
just vim-plugins-install
nvim
```

Then run `:LspBootstrap` from Neovim to install the configured Mason LSP dependencies. Restart Neovim afterward if the first launch installed missing plugins.

### Optional tooling
- Telescope pickers expect [`ripgrep`](https://github.com/BurntSushi/ripgrep) and [`fd`](https://github.com/sharkdp/fd) on `$PATH`.
- Sidekick can attach to installed local AI CLIs. Install the CLIs you want to use separately, then pick one from Neovim with `<Leader>as`.
- Sidekick CLI sessions use tmux persistence when Neovim is running inside tmux.
- Sidekick NES requires a GitHub Copilot subscription or Copilot Free access.
- Language-specific runtimes (Go, Python, etc.) should be installed before launching Mason or DAP adapters.
- Go tooling for Vim is installed with `just vim-go-binaries` after `just vim-plugins-install`.

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

## Vim Configuration

Vim uses `.vimrc` plus shared settings and mappings from `.vim/common.vim`. `.vimrc` loads Vim's `defaults.vim` for modern stock behavior, then layers this repo's choices on top.

Plugins load through Vim's native package directories:

```text
~/.vim/pack/plugins/start/{plugin}
```

The `justfile` clones and updates those Git repositories because Vim native packages handle loading, not installation.

The Vim plugin set is intentionally smaller:
- `tpope/vim-surround`
- `tpope/vim-unimpaired`
- `tpope/vim-fugitive`
- `airblade/vim-gitgutter`
- `fatih/vim-go`
- `github/copilot.vim`
- `terrastruct/d2-vim`

Vim keeps using `github/copilot.vim` for Copilot. Neovim does not load `github/copilot.vim`; it uses Sidekick with the native `copilot` LSP config instead. Shared mappings live in `.vim/common.vim`; Neovim-only mappings live in `.config/nvim/lua/es/keymaps.lua`.

### Vim baseline
The Vim baseline is intentionally close to stock modern Vim:
- `.vimrc` loads `defaults.vim` when running Vim.
- `.vim/common.vim` sets personal editing preferences like line numbers, two-space indentation, dark background, split direction, search behavior, shared keymaps, and fold helpers.
- `cursorline` is left off.
- No named Vim colorscheme is set. `set background=dark` lets Vim's default highlights render against the terminal or tmux palette.
- Plugins load from native packages.

Useful checks inside Vim:

```vim
:set background?
:set cursorline?
:echo exists("g:colors_name") ? g:colors_name : "none"
```

### Vim package commands
Run these from the repo after syncing `.vim/` and `.vimrc` into `$HOME`:

```bash
just vim-plugins-install  # clone missing Vim packages
just vim-plugins-update   # git pull --ff-only existing Vim packages
just vim-go-binaries      # run vim-go's :GoUpdateBinaries
```

The default package root is `~/.vim/pack/plugins`. Override it with:

```bash
VIM_PACK_ROOT=/path/to/pack/plugins just vim-plugins-install
```

### Vim package inspection
Vim does not have a built-in `:PackStatus` screen. Use stock Vim commands:

```vim
:scriptnames
:set runtimepath?
:set packpath?
:echo globpath(&packpath, 'pack/*/start/vim-fugitive')
```

Useful help topics:

```vim
:help defaults.vim
:help packages
:help pack-add
:help packpath
:help scriptnames
```

## Neovim Configuration

### Plugin stack
| Category | Plugins |
| --- | --- |
| Formatting | `stevearc/conform.nvim` |
| LSP | `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim`, `jay-babu/mason-nvim-dap.nvim` |
| Treesitter | `nvim-treesitter/nvim-treesitter`, `nvim-treesitter/nvim-treesitter-context` |
| Completion | `hrsh7th/nvim-cmp`, `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`, `hrsh7th/cmp-cmdline`, `hrsh7th/cmp-nvim-lsp` |
| Debugging | `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `mfussenegger/nvim-dap-python`, `leoluz/nvim-dap-go`, `nvim-neotest/nvim-nio` |
| Telescope | `nvim-telescope/telescope.nvim`, `nvim-telescope/telescope-file-browser.nvim`, `nvim-telescope/telescope-live-grep-args.nvim`, `nvim-telescope/telescope-fzf-native.nvim` |
| UI | `echasnovski/mini.icons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `ellisonleao/glow.nvim`, `stevearc/oil.nvim`, `karb94/neoscroll.nvim` |
| Navigation | `folke/flash.nvim` |
| Productivity | `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim`, `folke/sidekick.nvim` |
| Language Extras | `fatih/vim-go`, `terrastruct/d2-vim` |


> Neovim plugins are registered explicitly in `.config/nvim/lua/es/pack.lua` via `vim.pack.add()` and configured from `.config/nvim/lua/es/plugins/*.lua`. Feature loading is split between startup modules and autocommand-triggered modules in `pack.lua`, and `PackChanged` hooks run post-install steps like `:TSUpdate`, `:MasonUpdate`, `:GoUpdateBinaries`, and `make` for `telescope-fzf-native.nvim` when applicable.
>
> The configuration follows modern Neovim 0.12 idioms with the native package manager, built-in LSP client, and centralized Lua setup modules.

### Sidekick NES
Sidekick's Next Edit Suggestions use the Copilot language server for larger edit suggestions after you pause, leave insert mode, or modify text in normal mode. Vim still uses `github/copilot.vim` from `.vimrc`; Neovim uses Sidekick with the native `copilot` LSP config so only one Copilot LSP client runs.

After deploying the Neovim config:
1. Start Neovim and run `:LspBootstrap` so Mason installs the configured LSP servers.
2. Restart Neovim if this was the first plugin/LSP bootstrap.
3. Open a file inside a git-backed project and run `:checkhealth sidekick`.
4. If prompted, run `:LspCopilotSignIn` and complete the GitHub device flow.

The normal install path is `:LspBootstrap`. The LSP config name is `copilot`, but Mason's package name is `copilot-language-server`; search for the package name in `:Mason`.

If bootstrap did not install it, run the Mason package install directly:

```vim
:MasonInstall copilot-language-server
```

Usage:
- Type normally, pause, or leave insert mode to let NES request suggestions.
- Press `<Tab>` to jump to the suggested edit or apply it. If no NES action is available, `<Tab>` falls back to native inline completion and then to a normal tab.
- Run `:Sidekick nes update` to request a suggestion manually.
- Run `:Sidekick nes toggle` if you want to temporarily disable or re-enable NES.

### Keymaps
The detailed Vim and Neovim keymap reference lives in [docs/keymaps.md](docs/keymaps.md). Shared Vim/Neovim mappings are sourced from `.vim/common.vim`; Neovim-specific mappings are centralized in `.config/nvim/lua/es/keymaps.lua`.
