# Agent Directives & Repository Guidelines

## Scope & Deployment Boundaries
- **Workspace Containment**: Confine every write — file creation, edits, and any side effect of a command — to the repository workspace directory (`/Users/earl/dev/repos/dotfiles`). A command is out of scope if the process it starts writes outside the workspace, even when invoked from within it.
- **Read-Only Inspection Is Encouraged**: Read freely outside the workspace when diagnosing: installed plugin source (`~/.local/share/nvim/site/pack/`), the Neovim runtime (`$VIMRUNTIME`), and the deployed copies under `~/.config/`. Never write to them.
- **Editor Runs Are Isolated**: Diagnose configs with `just nvim-probe` / `just nvim-eval`, which boot Neovim headless against a throwaway runtime built from a copy of this repo. Never invoke `nvim`/`vim` directly, and never point a config root (`XDG_CONFIG_HOME`, `NVIM_APPNAME`, `-u`) at `$HOME` or at the workspace. Launching Neovim against `$HOME` mutates the live runtime (`nvim-pack-lock.json`, shada, `~/.cache/nvim`, Mason and Treesitter state); pointing a config root at the workspace deposits `nvim-pack-lock.json` into the changeset.
- **Never Escalate Out Of A Sandbox**: If the agent runtime sandboxes commands, a denial for a path outside the workspace is this policy working as intended. Report it and stop. Never re-run the command with the sandbox disabled.
- **Runtime Artifact Check**: `nvim-pack-lock.json`, `*.shada`, `.netrwhist`, and `nvim.log` must never exist in the worktree. These are deliberately **not** gitignored so an escape surfaces as an untracked file in `git status` — never silence one by adding an ignore rule. `just check-containment` is the secondary sweep for anything a global excludes file still hides. Report any hit and never commit it.
- **User-Driven Synchronization**: Treat this repository as the sole source of truth. Changes in this repository are synced into `$HOME` (`~/.config/`, `~/.vim/`) exclusively by the user running their local sync scripts.
- **Git Command Scope**: Interpret user requests to "ship", "deploy", or "merge" as instructions to stage, commit, or branch within the git repository workspace.
- **Environment Stability**: Leave live runtime environments, plugin caches, and pack lockfiles untouched unless the user explicitly requests maintenance commands.

## Default-First Protocol
This repo is default-first (README "Philosophy"): Vim and Neovim start from native behavior, and config exists only for preferences worth carrying between machines. Before adding any keymap, option, or plugin setting, establish that the editor or the plugin does not already provide it.
- **Check Before Adding**: Consult `:h vim-defaults`, `:h lsp-defaults`, and the plugin's own preset — e.g. `cmp.mapping.preset.insert` deliberately maps `<C-n>`/`<C-p>`/`<C-y>` to mirror Neovim's native ins-completion, and deliberately leaves `<Tab>` alone. Prefer removing a deviation over adding config that compensates for one.
- **Own What You Displace**: Overriding a default means reimplementing every behavior it carried. The insert-mode `<Tab>` map in `keymaps.lua` is the worked example: it exists only because Neovim ships no default for `vim.lsp.inline_completion.get()`, and it restores `vim.snippet.jump` and a literal `<Tab>` because it displaced both.
- **Cite The Docs**: When an override is justified, name the `:h` tag for the mechanism in a comment beside it, so the next reader can distinguish a deliberate override from an accident.
- **Regression Triage**: When a behavior "used to work", check git history for what the default was before concluding a feature is missing. Restoring a default is more often the fix than adding a mapping.

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

Agent-safe commands — these write only inside the workspace or the throwaway probe runtime:

| Command | Purpose |
| :--- | :--- |
| `just check-containment` | Fails if runtime artifacts reached the worktree |
| `just nvim-probe *args` | Boots Neovim headless against the isolated probe runtime (e.g. `just nvim-probe +PackStatus`) |
| `just nvim-eval '<lua>'` | Evaluates Lua in the probe runtime and prints the result |
| `just nvim-probe-clean` | Discards the probe runtime and its cloned plugin tree |
| `luac -p <file>` | Syntax-checks a Lua module without booting an editor |
| `uv sync --group dev` | Installs local Python helpers declared in `pyproject.toml` |
| `uv run python -m isort .` | Sorts Python imports across the workspace |

User-only commands — these mutate the live runtime in `$HOME`, so agents must never run them:

| Command | Purpose |
| :--- | :--- |
| `nvim` | Bootstraps plugins via `vim.pack` on first launch |
| `nvim +"PackStatus"` | Displays managed plugin status |
| `nvim +"PackUpdate"` | Updates plugins registered in `.config/nvim/lua/es/pack.lua` |
| `nvim +"Mason"` | Opens Mason UI for LSP/DAP tooling |

## Coding Style & Conventions
- **Language & Style**: Lua for Neovim config using 2-space indentation and `snake_case` module filenames under `es/`.
- **Wiring**: Wire plugins directly via `require("es.plugins.<name>").setup()` inside `pack.lua`.
- **Responsibility Isolation**: Place startup UI in `startup`, buffer-driven features in autocommands, and filetype logic in dedicated handlers. Keep modules small and single-purpose.

## Testing & Verification Protocol
- **Agent-Side Checks**: Verify by reading code, syntax-checking with `luac -p`, and querying the isolated probe runtime via `just nvim-eval`. Confirm plugin API assumptions by reading the installed plugin's source under `~/.local/share/nvim/site/pack/`, never by running it against `$HOME`.
- **Probe Limits**: The probe boots headless, so it can confirm configuration state (loaded modules, mapping tables, option values) but cannot exercise keystrokes, popup menus, or anything requiring a UI and real input loop. Never present a probe result as proof that an interaction works.
- **Report Verification Honestly**: State which parts of a change are statically verified and which still need the user's live session.
- **User-Side Verification**: Perform manual verification in interactive editor sessions.
- After the user syncs `.config/nvim/` into their runtime environment, verify the target command, keymap, or UI workflow in a live session.
- For plugin-loading changes, verify both clean dashboard startup and opening a file.

## Commit & Workflow Standards
- **Commit Formatting**: Use concise, scoped conventional commit messages (e.g. `refactor(nvim): initialize mason separately from lazy lsp setup`). Focus each commit on a single subsystem.
- **PR Descriptions**: Clearly describe user-visible behavior changes and list any required runtime sync steps. Reserve screenshots for visual UI changes.
- **State Cleanliness**: Keep commits focused on source configuration files, excluding machine-specific secrets, cache, or lockfile churn.
