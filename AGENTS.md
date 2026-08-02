# Agent Directives & Repository Guidelines

## Scope & Deployment Boundaries
- **Workspace Containment**: Restrict all file creation, edits, and command executions strictly to the repository workspace directory (`/Users/earl/dev/repos/dotfiles`).
- **User-Driven Synchronization**: Treat this repository as the sole source of truth. Changes in this repository are synced into `$HOME` (`~/.config/`, `~/.vim/`) exclusively by the user running their local sync scripts.
- **Git Command Scope**: Interpret user requests to "ship", "deploy", or "merge" as instructions to stage, commit, or branch within the git repository workspace.
- **Environment Stability**: Leave live runtime environments, plugin caches, and pack lockfiles untouched unless the user explicitly requests maintenance commands.

## Project Structure & Architecture Map
- **Neovim Lua Root**: `.config/nvim/lua/es/`
  - `pack.lua`: Defines plugin registrations and lazy-loading boundaries.
  - `plugins/`: Contains plugin setup modules.
  - `lsp/`: Contains per-server LSP configuration overrides.
  - Standalone modules (wrap no plugin): `keymaps.lua`, `options.lua`, `globals.lua`, `autocmds.lua`, `ui.lua`, `markdown_preview.lua`.
  - Language runners: `runner.lua` (core engine) plus `zig.lua`, `mojo.lua`, `odin.lua`, `rust.lua`, and `python.lua`.
- **Other Runtime Configs**: `.vimrc` and `.vim/` (Vim baseline), `.tmux.conf` (tmux).

## LSP & Language Integration
- **Treesitter Parsers**: Add entries to `plugins/treesitter.lua` strictly when parsers are bundled with Neovim.
- **LSP Registration** (`plugins/lsp.lua`):
  - `mason_servers`: Register servers installed and managed via Mason.
  - `external_servers`: Map external binaries provided outside Mason to their executable name. Probed once per session at launch on the first opened file to maintain machine portability.
  - `project_local_servers`: Register project-scoped servers (e.g. `.venv/bin/`). Enable unconditionally and delegate path resolution to the server module.
- **Per-Server Modules** (`lsp/<server>.lua`):
  - **Dynamic Scope Resolution**: Resolve per-project dynamic values inside Neovim client hooks called per client buffer. Keep top-level scope static to prevent freezing values to the initial buffer.
  - `cmd` (`fun(dispatchers, config)`): Use as the sole hook for varying the executable binary or process environment. Receives `config.root_dir` pre-resolved from `root_markers`.
  - `root_dir` (`fun(bufnr, on_dir)`): Use to control server activation. Execute `on_dir` to activate, or leave uncalled to keep the server off for that buffer.
  - `lsp/mojo.lua`: Combines `cmd` and `root_dir` to locate uv-installed `mojo-lsp-server` and append Modular libraries to the loader path.

## Code Execution & Runner Design
- **Stateful REPLs**: Route interactive sessions with maintained Jupyter kernels through `plugins/pyrepl.lua`.
- **Stateless Task Runner**: Route all other language executions through dedicated sub-modules built on `runner.lua` and registered in the `runner_modules` table in `keymaps.lua`.
  - `runner.lua`: Manages the output split buffer (filetype `taskrun`, closing via `q` in `autocmds.lua`), process groups, and termination (`<Leader>xs`).
  - Runner Sub-modules: Limit implemented functions to verbs natively supported by the toolchain (`run`, `build`, `test`, `test_nearest`, `stop`).
- **Toolchain Resolution**:
  - Prioritize resolving project-local binaries (`.venv/bin/<tool>`) over global `$PATH`.
  - Verify executable existence using `vim.fn.executable()` for cross-platform portability.
  - Inspect and verify CLI flags against the installed binary before defining command invocations.

## Development & Command Reference
| Command | Purpose |
| :--- | :--- |
| `nvim` | Bootstraps plugins via `vim.pack` on first launch |
| `nvim +"PackStatus"` | Displays managed plugin status |
| `nvim +"PackUpdate"` | Updates plugins registered in `.config/nvim/lua/es/pack.lua` |
| `nvim +"Mason"` | Opens Mason UI for LSP/DAP tooling |
| `uv sync --group dev` | Installs local Python helpers declared in `pyproject.toml` |
| `uv run python -m isort .` | Sorts Python imports across the workspace |

## Coding Style & Conventions
- **Language & Style**: Lua for Neovim config using 2-space indentation and `snake_case` module filenames under `es/`.
- **Wiring**: Wire plugins directly via `require("es.plugins.<name>").setup()` inside `pack.lua`.
- **Responsibility Isolation**: Place startup UI in `startup`, buffer-driven features in autocommands, and filetype logic in dedicated handlers. Keep modules small and single-purpose.

## Testing & Verification Protocol
- Perform manual verification in interactive editor sessions.
- After the user syncs `.config/nvim/` into their runtime environment, verify the target command, keymap, or UI workflow in a live session.
- For plugin-loading changes, verify both clean dashboard startup and opening a file.

## Commit & Workflow Standards
- **Commit Formatting**: Use concise, scoped conventional commit messages (e.g. `refactor(nvim): initialize mason separately from lazy lsp setup`). Focus each commit on a single subsystem.
- **PR Descriptions**: Clearly describe user-visible behavior changes and list any required runtime sync steps. Reserve screenshots for visual UI changes.
- **State Cleanliness**: Keep commits focused on source configuration files, excluding machine-specific secrets, cache, or lockfile churn.
