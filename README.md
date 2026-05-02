# dotfiles

## Overview
Personal configuration for Neovim, Vim, tmux, and assorted CLI tools.

## Table of Contents
- [Quick Start](#quick-start)
  - [Base editor prerequisites](#base-editor-prerequisites)
  - [Tree-sitter + Node.js toolchain](#tree-sitter--nodejs-toolchain)
  - [Python support for Neovim/DAP](#python-support-for-neovimdap)
  - [Plugin bootstrap (vimpack)](#plugin-bootstrap-vimpack)
  - [Reset and reinstall](#reset-and-reinstall)
  - [Optional tooling](#optional-tooling)
- [tmux Configuration](#tmux-configuration)
  - [Setup](#setup)
  - [tmux Keymaps](#tmux-keymaps)
- [Vim Configuration](#vim-configuration)
- [Neovim Configuration](#neovim-configuration)
  - [Plugin stack](#plugin-stack)
  - [Sidekick NES](#sidekick-nes)
  - [Keymaps](#keymaps)
    - [Neovim defaults](#neovim-011-defaults-no-leader)
    - [LSP operations](#lsp-operations-leaderl)
    - [Diagnostic operations](#diagnostic-operations-leaderd)
    - [AI operations](#ai-operations-leadera)
    - [Debug operations](#debug-operations-leaderb)
    - [Find operations](#find-operations-leaderf)
    - [Git operations](#git-operations-leaderg)
    - [Hunk operations](#hunk-operations-leaderh-and-leadert)
    - [NvimTree](#nvimtree-leadere)
    - [Flash navigation](#flash-navigation)
    - [Other mappings](#other-mappings)
    - [Shared keymaps](#shared-keymaps-vimcommonvim)
    - [nvim-cmp completion](#nvim-cmp-completion)

## Quick Start

### Base editor prerequisites
1. Install current releases of Vim and Neovim.
2. Install a Nerd Font (I usually grab one from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)).
3. Sync the tracked runtime files from this repo into `$HOME`, including:
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

### Plugin bootstrap (vim.pack)
Neovim 0.12 manages plugins with the native `vim.pack` package manager from `.config/nvim/lua/es/pack.lua`.
On first launch, `vim.pack` installs plugins into Neovim's managed package directory and creates `~/.config/nvim/nvim-pack-lock.json`.
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
If you want to wipe the tracked editor/shell config plus local Neovim state under `$HOME` and reinstall from this repo:

1. Back up or remove the current config and runtime data.

```bash
mkdir -p ~/dotfiles-backup
mv ~/.vim ~/.vimrc ~/.config/nvim ~/.tmux.conf ~/.cargo/config ~/.config/starship.toml \
  ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/dotfiles-backup/ 2>/dev/null
```

2. If you prefer deletion instead of backup for Neovim runtime state, this is also a valid clean reset:

```bash
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

4. Start Neovim once so `vim.pack` can install plugins.

```bash
nvim
```

Then run `:LspBootstrap` from Neovim to install the configured Mason LSP dependencies. Restart Neovim afterward if the first launch installed missing plugins.

### Optional tooling
- Telescope pickers expect [`ripgrep`](https://github.com/BurntSushi/ripgrep) and [`fd`](https://github.com/sharkdp/fd) on `$PATH`.
- Sidekick can attach to installed local AI CLIs. Install the CLIs you want to use separately, then pick one from Neovim with `<Leader>As`.
- Sidekick CLI sessions use tmux persistence when Neovim is running inside tmux.
- Sidekick NES requires a GitHub Copilot subscription or Copilot Free access.
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

## Vim Configuration

Vim uses `.vimrc` plus the shared settings and mappings in `.vim/common.vim`. Plugins are managed by vim-plug from `.vimrc`, separate from Neovim's native `vim.pack` setup.

The Vim plugin set is intentionally smaller:
- `tpope/vim-surround`
- `tpope/vim-unimpaired`
- `tpope/vim-fugitive`
- `airblade/vim-gitgutter`
- `fatih/vim-go`
- `github/copilot.vim`
- `terrastruct/d2-vim`

Vim keeps using `github/copilot.vim` for Copilot. Neovim does not load `github/copilot.vim`; it uses Sidekick with the native `copilot` LSP config instead. Shared mappings live in `.vim/common.vim`, while Neovim-only mappings live in `.config/nvim/lua/es/keymaps.lua`.

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
Most Neovim keymaps are centralized in `.config/nvim/lua/es/keymaps.lua`. Buffer-local keymaps (like gitsigns) are defined in keymaps.lua as exported functions and called from plugin on_attach callbacks. Shared vim/neovim keymaps live in `.vim/common.vim`. Leader key is `<Space>`.

The keymap system follows a consistent namespace that mirrors the Neovim API:
- **`<Leader>l*`** = LSP operations (mirrors `vim.lsp.buf.*` API)
- **`<Leader>d*`** = Diagnostic operations (mirrors `vim.diagnostic.*` API, navigation uses `]d`/`[d` defaults)
- **`<Leader>b*`** = Debug/breakpoint operations (DAP)
- **`<Leader>A*`** = AI CLI operations (Sidekick)
- **`<Leader>f*`** = Find operations (Telescope with ripgrep/fd)
- **`<Leader>h*`** = Hunk operations (gitsigns, buffer-local in git files)
- **`<Leader>t*`** = Toggle operations (gitsigns)
- **`<Leader>g*`** = Git operations (Fugitive)
- **`<Leader>e*`** = NvimTree operations (explorer/file tree navigation)

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
| `<Leader>lf` | Format (conform) |
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

#### AI operations (`<Leader>A*`)
Sidekick manages terminal sessions for installed AI CLIs. NES setup and usage are covered in the Sidekick NES section above.

Typical flow:
1. Use `<Leader>As` to choose an installed CLI.
2. Use `<Leader>Aa` to open or hide the Sidekick terminal.
3. Send context with `<Leader>At`, `<Leader>AF`, or visual `<Leader>Av`.
4. Use `<Leader>Ap` when you want to type a one-off prompt with the current context.

| Shortcut | Action |
| --- | --- |
| `<Leader>Aa` | Toggle Sidekick CLI |
| `<Leader>Af` | Focus Sidekick CLI |
| `<Leader>As` | Select an installed CLI |
| `<Leader>Ad` | Detach/close Sidekick CLI |
| `<Leader>At` | Send current context (`{this}`) |
| `<Leader>AF` | Send current file (`{file}`) |
| `<Leader>Av` | Send visual selection (`{selection}`) |
| `<Leader>Ap` | Prompt Sidekick |

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
Hidden file search (`<Leader>fh`) and the directory picker that feeds Oil (`<Leader>fD`) share the same fd exclude list in `.config/nvim/lua/es/keymaps.lua`, so you can tweak which build artifacts or vendor dirs stay hidden in one place.

| Shortcut | Action |
| --- | --- |
| `<Leader>ff` | Find files |
| `<Leader>fr` | Find with ripgrep (live grep) |
| `<Leader>fb` | Find buffers |
| `<Leader>fg` | Find git files |
| `<Leader>fo` | Find oldfiles (recent) |
| `<Leader>fh` | Find hidden files |
| `<Leader>fD` | Browse directories (Oil) |
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

#### NvimTree (`<Leader>e*`)
File tree navigation.

| Shortcut | Action |
| --- | --- |
| `<Leader>et` | NvimTree toggle |
| `<Leader>ef` | NvimTree find file |
| `<Leader>ec` | NvimTree close |
| `<Leader>ep` | NvimTree open parent directory |
| `<Leader>eo` | NvimTree open Oil directory |


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
| `<CR>` | Accepts the LSP (Popup Menu) selection. |
| `<C-n>` / `<C-p>` | Navigates up and down the LSP menu. |
