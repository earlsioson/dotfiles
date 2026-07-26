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
* **Deno**: TypeScript runtime, package manager, language server, and Pyrepl Jupyter kernel. Install the binary at `~/.local/bin/deno`, then register its built-in kernel once with `deno jupyter --install`.
* **Zig**: Compiler and toolchain on `$PATH`, paired with `zls` (Zig language server). Both are static binaries installed outside Mason and declared as `external_server` entries in `es/plugins/lsp.lua`. Keep the two version-matched; `zls` tracks the compiler release series.
* **Mojo** (optional): runs only on Apple silicon macOS and Ubuntu 22.04 or later, so it is absent on Intel Macs. Installed per project with uv rather than globally — see the Mojo section below. Both the `mojo` language server and the runner mappings are skipped when the toolchain is missing, so the configuration stays portable across machines.
* **Odin** (optional): compiler on `$PATH`, paired with `ols` (Odin Language Server, a separate binary). Both are declared as `external_server` entries and gated on their executables, so an absent toolchain leaves the configuration inert rather than broken.
* **Ruff** (Python linter/formatter): binary on `$PATH` — `brew install ruff` or the [astral installer](https://astral.sh/ruff/install.sh). Not Mason-managed; declared as `external_server` in `es/plugins/lsp.lua`.
* **Formatter binaries**: `stylua`, `black`, and `rumdl` are used when formatting their corresponding filetypes and must be present on `$PATH`. `isort` is installed by the development dependency group above. `biome` formats JavaScript, TypeScript, CSS, HTML, and JSON, but needs no manual installation because Mason already provides it as a language server. Mojo formatting shells out to `mojo format` rather than a separate binary, so it follows the Mojo toolchain and is unavailable when that toolchain is not installed.
* **Pandoc**: Required by `<Leader>mp` to render Markdown as a temporary HTML document in the default browser.
* **Language-specific runtimes** (Go, Python, Deno, etc.) must be present on `$PATH` before configuring corresponding LSP servers or debug adapters.

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
| **UI** | `echasnovski/mini.icons`, `windwp/nvim-autopairs`, `folke/tokyonight.nvim`, `nvim-tree/nvim-tree.lua`, `nvim-lualine/lualine.nvim`, `nvimdev/dashboard-nvim`, `stevearc/oil.nvim`, `karb94/neoscroll.nvim`, `folke/which-key.nvim` |
| **Navigation** | `folke/flash.nvim` |
| **Productivity** | `tpope/vim-surround`, `tpope/vim-unimpaired`, `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim`, `folke/sidekick.nvim` |
| **Language Extras** | `fatih/vim-go`, `terrastruct/d2-vim` |

### Interactive REPLs
Pyrepl embeds `jupyter-console` for Python and TypeScript code. It can display plots and other rich image output using its built-in Ghostty-compatible image provider. Python and notebook buffers preload the feature; the `<Leader>p` mappings load it on demand from JavaScript and TypeScript buffers.

#### Python projects

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

#### Deno projects

Deno bundles its TypeScript runtime, package manager, language server, formatter, linter, test runner, and Jupyter kernel in one executable. The kernel is registered once per user rather than once per project:

```sh
uv sync --group dev
source .venv/bin/activate
deno jupyter --install
```

Create and use a project with:

```sh
deno init
deno add zod
deno run main.ts
deno test
```

Projects use `deno.json` and `deno.lock`; they do not need a virtual environment or `ipykernel`. Start Neovim from the project root so the Jupyter kernel inherits the correct working directory. `denols` attaches automatically when it finds `deno.json`, `deno.jsonc`, or `deno.lock`, while non-Deno TypeScript projects continue to use `ts_ls`.

The `deno jupyter` command currently prints an upstream warning that the subcommand is unstable. This refers to the Jupyter integration API and does not affect the stability of the Deno runtime or language server.

#### Commands and mappings

* `:PyreplOpen` (`<Leader>po`): Open Deno automatically for JavaScript/TypeScript; for Python, open the registered kernel whose interpreter matches the current project's `.venv`; otherwise prompt. Use `:PyreplOpen!` to always choose interactively.
* `:PyreplToggle` (`<Leader>pt`): Show or hide the REPL.
* `:PyreplToggleFocus` (`<Leader>pf`): Move between the source buffer and REPL.
* `:PyreplSendBuffer` (`<Leader>pb`): Send the entire buffer.
* `:PyreplSendCell` (`<Leader>pc`): Send the cell under the cursor; Python uses `# %%`, while JavaScript and TypeScript use `// %%`.
* `:PyreplSendVisual` (`<Leader>pv`): Send the most recent visual selection.
* `:PyreplOpenImageHistory` (`<Leader>pi`): Browse generated plots and other images.

When the REPL has focus, the terminal consumes keystrokes instead of invoking normal-mode mappings. Press `<Leader><Esc>` (`<Space>`, then `<Esc>`) to leave terminal-input mode, then `<Leader>pf` to return to the source buffer. Neovim's built-in `<C-\><C-n>` sequence remains available as a fallback.

Run `uv sync --group dev` from the dotfiles repository to install the console and image dependencies. After syncing `.config/nvim/` and `.vim/` into their corresponding home-directory paths, open a supported source file and restart Neovim once if `vim.pack` installs Pyrepl during that session.

Inline plots require a Kitty-graphics-capable terminal such as Ghostty. Through SSH, sync and load `.tmux.conf` on the remote host; every nested tmux layer must report `on` from `tmux show-options -gv allow-passthrough`. Jupytext is required only for notebook conversion.

### Zig
Zig support is deliberately thin: no plugin, no wrapper module, and no server-specific override file. Neovim detects the `zig` filetype natively, `nvim-treesitter` installs the `zig` parser for highlighting, folding, and indentation, and `zls` provides completion, hover, references, and diagnostics. Debugging already works through the existing `nvim-dap` setup, which maps Zig to the C/C++ adapter configuration.

#### Build-on-save diagnostics

`zls` reports real compile errors — not just the syntax and semantic subset it can derive on its own — by invoking `zig build` when a file is saved. This is left entirely to `zls`'s own auto-detection rather than being forced on in this repository, because the behavior is correct only when it is decided per project:

* When a project's `build.zig` declares a `check` step, `zls` enables build-on-save automatically and prefers that step over the default `install` step.
* When no `check` step exists, `zls` leaves the feature off. Forcing `enable_build_on_save` on globally would fall back to the `install` step, which runs full LLVM code generation on every save.

Opt a project in by declaring a `check` step whose artifact is never passed to `b.installArtifact`. Omitting the install is the entire point: it adds `-fno-emit-bin`, so the compiler analyzes the code and reports errors without entering the code-generation phase.

```zig
const exe_check = b.addExecutable(.{
    .name = "example",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    }),
});

const check = b.step("check", "Type-check without emitting a binary");
check.dependOn(&exe_check.step);
// Intentionally no b.installArtifact(exe_check) — that is what enables -fno-emit-bin.
```

The `build.zig` API tracks the compiler release, so adjust the snippet to match the installed Zig version. Loose `.zig` files outside a project still get full `zls` analysis; only the build-driven diagnostics require a project root.

#### Running and testing

Zig uses the shared code runner described under [Code Runner](#code-runner): one-shot compile-and-run with no session, which is why it sits under `<Leader>c` rather than alongside the kernel-backed `<Leader>p` mappings. Compile errors appear in the output split as ordinary output; persistent in-editor diagnostics remain `zls`'s responsibility.

* `<Leader>cr`: Run. Uses `zig build run` when a `build.zig` is found, otherwise `zig run` on the current file.
* `<Leader>ca`: Run all tests. Uses `zig build test --summary all` in a project, otherwise `zig test` on the current file. The summary flag is required because `zig build test` prints nothing on success, leaving a passing run indistinguishable from one that executed no tests.
* `<Leader>ct`: Run the nearest test. Scans upward for the enclosing `test "name"` block and passes it to `--test-filter`.
* `<Leader>cs`: Terminate the running command.

A project is identified by `build.zig` alone, not by `.git`, so loose Zig files inside a repository are still treated as standalone. Note that `<Leader>ct` always compiles the current file on its own so that `--test-filter` applies. Because Zig analyzes declarations lazily, this succeeds more often than expected: a file may import modules declared only in `build.zig` and still run a filtered test cleanly, provided that test does not reach those imports. When a test does depend on the build graph, the standalone compile fails to resolve the module; use `<Leader>ca` for those.

### Mojo
Mojo shares the code runner but needs far less of it. `mojo run` builds and executes a single file rather than driving a build system, so there is no project versus loose-file distinction. The `mojo test` command was removed on 31 October 2025 because discovery happened outside the compiled artifact, which produced confusing failures when test files imported stale modules. Tests are now ordinary executables, which means `<Leader>cr` runs a program and a test file identically:

```mojo
from std.testing import assert_equal, TestSuite

def test_example() raises:
    assert_equal(inc(1), 2)

def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
```

Test functions are discovered by their `test_` prefix, must take no arguments, and signal failure by raising. There is no filtering of individual tests, which is why Mojo binds no `<Leader>ct`.

#### Platform support and installation

Mojo builds exist only for Apple silicon macOS and Ubuntu 22.04 or later (x86-64 with SSE4.2, or Graviton2/3). Intel Macs are unsupported, so this configuration must degrade rather than break: `es/plugins/lsp.lua` enables an external language server only when its executable is present, and `es/mojo.lua` reports a missing toolchain instead of failing.

Install per project with uv:

```sh
uv init my-project
cd my-project
uv add mojo --prerelease allow
```

`--prerelease allow` is required while Mojo is in beta. Avoid `uv tool install mojo`: tool isolation breaks Mojo's cross-package binary dependencies and the compiler fails to locate LLDB. Because uv installs the toolchain into the project's `.venv` rather than onto `$PATH`, `es/mojo.lua` looks for `.venv/bin/mojo` beneath the nearest `pyproject.toml` before falling back to `$PATH` — the same resolution order Pyright uses to find a project interpreter. The language server is resolved by `$PATH` alone, so activate the virtualenv to get `mojo-lsp-server`.

Mojo documentation now lives at [mojolang.org](https://mojolang.org), separate from the MAX documentation at `docs.modular.com`.

#### MAX

MAX needs no separate configuration. Its primary interface is a Python library, so MAX work is Python work: install it into a project virtualenv, register a Jupyter kernel for that environment, and the existing `<Leader>p` Pyrepl mappings pick it up through the interpreter matching described above. A real kernel keeps session state, which matters when a loaded model should survive between cells.

### Odin
Odin compiles a directory rather than a file: every `.odin` file in a folder forms one package, and `odin run .` builds them together. A single file must opt out explicitly with `odin run file.odin -file`. The runner therefore acts on the directory holding the current buffer, and no build manifest or root marker is involved.

Tests are procedures carrying the `@(test)` attribute:

```odin
package tests

import "core:testing"

@(test)
my_test :: proc(t: ^testing.T) {
    testing.expect(t, 2 + 2 == 4, "arithmetic failed")
}
```

`<Leader>ct` runs a single test through `-define:ODIN_TEST_NAMES=<package>.<proc>`. The qualifier comes from the file's `package` declaration, which need not match the directory name, so the runner reads it from the buffer rather than inferring it from the path. Grouped attributes such as `@(test, private)` are recognised.

`ols` resolves its workspace from `ols.json`, `.git`, or any `.odin` file, so the upstream defaults are used unchanged. Unlike Mojo, Odin builds for Intel Macs as well as Apple silicon and Linux.

### Code Runner
`es/runner.lua` holds everything the language runners share: the reused `task://output` scratch split, chunked stdout and stderr reassembly, and process control. Commands run detached in their own process group, because a build driver usually spawns the compiled program as a grandchild — signalling only the driver would leave that grandchild alive holding the output pipes open, so the exit callback would never fire. `<Leader>cs` signals the whole group and reports immediately rather than waiting on that callback.

Language modules supply only commands. Adding a language means writing one small module, adding a line to the `runner_modules` table in `es/keymaps.lua`, and registering the language server and treesitter parser. Verbs are bound only when the module implements them, so each language exposes exactly what its toolchain supports rather than a uniform set with dead keys.

### Sidekick & Copilot LSP Configuration
Next Edit Suggestions (NES) use the `copilot` LSP client configuration.
* **LSP Integration**: Initialized via `vim.lsp.enable("copilot")`. The underlying Mason server package name is `copilot-language-server`.
* **Authentication**: Signs in using the `:LspCopilotSignIn` command via the GitHub device verification flow.
* **Inline Completion**: Copilot suggestions refresh automatically in insert mode. `<Tab>` accepts the visible suggestion; `<C-Space>` opens the regular `nvim-cmp` LSP completion menu.
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
