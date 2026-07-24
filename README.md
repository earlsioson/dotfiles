# dotfiles

## Overview
Personal configuration for Neovim, Vim, tmux, and assorted CLI tools.

## Philosophy
This repo is default-first. Vim and Neovim start from their native behavior, adding only the preferences and workflow shortcuts worth carrying between machines.

The configurations follow each tool's idioms:
- **Vim**: Uses Vimscript, `defaults.vim`, and native packages under `~/.vim/pack`.
- **Neovim**: Uses Lua, `vim.pack` package management, built-in LSP defaults, and lazy-loaded feature modules.
- **Shared Behavior**: Defined in [common.vim](.vim/common.vim). Neovim-only additions live in [keymaps.lua](.config/nvim/lua/es/keymaps.lua).

## Configuration Layout
The repository contains the following configurations mapping to standard paths in `$HOME`:

* **[common.vim](.vim/common.vim)** -> Shared settings (indentation, line numbers, search defaults, and core keymaps).
* **[.vimrc](.vimrc)** -> Vim baseline configuration.
* **[.vim/](.vim/)** -> Shared Vim runtime configuration. Installed native packages live under the runtime copy at `~/.vim/pack`.
* **[.config/nvim/](.config/nvim/)** -> Neovim Lua environment (`init.lua`, package specs, options, and plugin setups).
* **[.tmux.conf](.tmux.conf)** -> tmux configuration (prefix set to `<C-Space>`, options, and TPM plugins).
* **[.cargo/config](.cargo/config)** -> Cargo options.
* **[.config/starship.toml](.config/starship.toml)** -> Starship prompt layout and modules.

---

## Dependencies & Prerequisites

### System Requirements
* Current releases of **Vim**, **Neovim** (>= 0.12), **Git**, **`just`**, **tmux**, **Bash**, and **`uv`**.
* **ripgrep** (`rg`) and **fd** for Telescope search, plus **make** and a C toolchain for native plugin builds.
* A **Nerd Font** (recommended for rendering Neovim UI icons).

### Language Toolchains & Runtimes
* **Node.js**: Required backend runtime for LSP servers and formatters.
* **Tree-sitter CLI & Neovim npm helper**: Required for parser compilation.
  * System packages: `tree-sitter-cli`, `neovim` (installed globally via `npm install -g`).
* **Python virtualenv**: Used for Neovim host, DAP, and the Pyrepl Jupyter console and image runtime.
  * Required packages are declared in `pyproject.toml`; project libraries such as Matplotlib do not belong in this environment.
  * Instantiation: Created using `uv sync --group dev` from the repository root (defined via `pyproject.toml` and `uv.lock`).
  * Configuration: `es/globals.lua` discovers the repository virtualenv and assigns it to `vim.g.python_host_path`.
* **Ruff** (Python linter/formatter): binary on `$PATH` — `brew install ruff` or the [astral installer](https://astral.sh/ruff/install.sh). Not Mason-managed; declared as `external_server` in `es/plugins/lsp.lua`.
* **Formatter binaries**: `stylua`, `black`, `rumdl`, and `mojo_format` are used when formatting their corresponding filetypes. `isort` is installed by the development dependency group above.
* **Glow**: The `glow` executable is required for the Markdown preview mapping.
* **Language-specific runtimes** (Go, Python, etc.) must be present on `$PATH` before configuring corresponding LSP servers or debug adapters.

---

## Package & Plugin Management

### Vim Package Management
Vim uses native packages located in:
```text
~/.vim/pack/plugins/start/{plugin}
```
The `vim_plugins` list in the repository [justfile](justfile) is the authoritative Vim plugin declaration. Vim automatically loads every package directory under `start`, so these plugins do not also need declarations in `.vimrc`. Removing a repository from `vim_plugins` makes its installed directory eligible for pruning on the next sync.

The `justfile` defines targets to manage these folders:
* `just vim-plugins-install`: Clones missing Vim package repositories.
* `just vim-plugins-update`: Pulls latest changes (`git pull --ff-only`) for all existing Vim packages.
* `just vim-plugins-prune`: Removes installed package directories that are no longer declared, after confirmation.
* `just vim-plugins-sync`: Installs missing plugins, updates declared plugins, prunes undeclared plugins, and regenerates help tags.
  For non-interactive automation, set `VIM_PLUGINS_PRUNE_FORCE=1` to acknowledge deletion of the listed stale directories.
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
| **Vim** | `~/.vim`, `~/.vimrc` | `~/.vim/pack/plugins/start` (managed plugin clones) |
| **Neovim** | `~/.config/nvim` | `~/.local/share/nvim` (plugins/data)<br>`~/.local/state/nvim` (logs/undo)<br>`~/.cache/nvim` (caches) |
| **tmux** | `~/.tmux.conf` | `~/.tmux/plugins` (TPM checkouts) |
| **Cargo** | `~/.cargo/config` | None |
| **Starship** | `~/.config/starship.toml` | None |

---

## tmux Configuration
* **TPM Plugin Manager**: Manages plugin life cycle via [tpm](https://github.com/tmux-plugins/tpm).
* **Prefix Key**: Configured to `Ctrl-Space` (`C-Space`).
* **Graphics Passthrough**: `allow-passthrough` forwards wrapped Kitty graphics sequences to Ghostty for inline Pyrepl plots. Every tmux layer must enable it, including tmux running on an SSH host.

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
| **LSP** | `neovim/nvim-lspconfig`, `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim` |
| **Treesitter** | `nvim-treesitter/nvim-treesitter`, `nvim-treesitter/nvim-treesitter-context` |
| **Completion** | `hrsh7th/nvim-cmp`, `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`, `hrsh7th/cmp-cmdline`, `hrsh7th/cmp-nvim-lsp` |
| **Debugging** | `mfussenegger/nvim-dap`, `jay-babu/mason-nvim-dap.nvim`, `rcarriga/nvim-dap-ui`, `mfussenegger/nvim-dap-python`, `leoluz/nvim-dap-go`, `nvim-neotest/nvim-nio` |
| **REPL** | `dangooddd/pyrepl.nvim` |
| **Telescope** | `nvim-telescope/telescope.nvim`, `nvim-telescope/telescope-file-browser.nvim`, `nvim-telescope/telescope-live-grep-args.nvim`, `nvim-telescope/telescope-fzf-native.nvim` |
| **UI** | `echasnovski/mini.icons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `ellisonleao/glow.nvim`, `stevearc/oil.nvim`, `karb94/neoscroll.nvim`, `folke/which-key.nvim` |
| **Navigation** | `folke/flash.nvim` |
| **Productivity** | `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim`, `folke/sidekick.nvim` |
| **Language Extras** | `fatih/vim-go`, `terrastruct/d2-vim` |

### Interactive REPLs
Pyrepl provides a Jupyter console for Python buffers and displays plot output using its built-in Ghostty-compatible image provider. It loads after opening a `*.py` or `*.ipynb` file, so its commands are intentionally unavailable on dashboard-only startup.

Python environment responsibilities remain separate:

* The dotfiles `.venv` runs the Pyrepl console and image tooling.
* Each project's `.venv` owns project libraries and runs code through a registered Jupyter kernel.
* Pyright automatically uses the current workspace's `.venv` when one exists.
* `:PyreplOpen` compares resolved interpreter paths and automatically opens the registered kernel backed by that same project `.venv`.

Set up a uv project for Matplotlib-backed REPL work with:

```sh
uv add matplotlib
uv add --dev ipykernel
uv run python -m ipykernel install --user \
  --name my-project \
  --display-name "Python (my-project)"
```

* `:PyreplOpen` (`<Leader>po`): Open the registered kernel whose interpreter matches the current project's `.venv`, or prompt when no match exists. Use `:PyreplOpen!` to always choose interactively.
* `:PyreplToggle` (`<Leader>pt`): Show or hide the REPL.
* `:PyreplToggleFocus` (`<Leader>pf`): Move between the source buffer and REPL.
* `:PyreplSendBuffer` (`<Leader>pb`): Send the entire buffer.
* `:PyreplSendCell` (`<Leader>pc`): Send the cell under the cursor; cells use `# %%` markers.
* `:PyreplSendVisual` (`<Leader>pv`): Send the most recent visual selection.
* `:PyreplOpenImageHistory` (`<Leader>pi`): Browse generated plots and other images.

Run `uv sync --group dev` from the dotfiles repository to install the console and image dependencies. After syncing `.config/nvim/` into `~/.config/nvim/`, open a Python file and restart Neovim once if `vim.pack` installs Pyrepl during that session.

Inline plots require a Kitty-graphics-capable terminal such as Ghostty. Through SSH, sync and load `.tmux.conf` on the remote host; every nested tmux layer must report `on` from `tmux show-options -gv allow-passthrough`. Jupytext is required only for notebook conversion.

### Sidekick & Copilot LSP Configuration
Next Edit Suggestions (NES) use the `copilot` LSP client configuration.
* **LSP Integration**: Initialized via `vim.lsp.enable("copilot")`. The underlying Mason server package name is `copilot-language-server`.
* **Authentication**: Signs in using the `:LspCopilotSignIn` command via the GitHub device verification flow.
* **Persistence**: AI CLI sessions automatically hook into `tmux` persistence to stay alive when Neovim restarts.

**Usage Mappings:**
* **Auto-Trigger**: Pausing, typing, or leaving insert mode prompts automatic suggestions.
* **`<Tab>`**: Applies active edit suggestion (falls back to inline completion or standard tab).
* **`:Sidekick nes update`**: Manually requests a suggestion at the cursor.
* **`:Sidekick nes toggle`**: Disables or re-enables Next Edit Suggestions.

### Keymaps Reference
Detailed Vim, Neovim, and tmux keymaps are documented in:
* **[docs/keymaps.md](docs/keymaps.md)** (Full reference manual)
* **[common.vim](.vim/common.vim)** (Shared Vim/Neovim mappings)
* **[keymaps.lua](.config/nvim/lua/es/keymaps.lua)** (Neovim-only mappings)
