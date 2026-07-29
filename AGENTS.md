# Repository Guidelines

## Project Structure & Module Organization
This repo stores personal editor and shell configuration. The main runtime files are `.config/nvim/` for Neovim, `.vim/` and `.vimrc` for Vim, and `.tmux.conf` for tmux. Neovim Lua code lives under `.config/nvim/lua/es/`: `plugins/` contains plugin setup modules, `lsp/` contains per-server settings, and `pack.lua` defines plugin registration and lazy-loading boundaries. Modules directly under `es/` are self-contained features that wrap no plugin — `keymaps.lua`, `options.lua`, `globals.lua`, `autocmds.lua`, `ui.lua`, `markdown_preview.lua`, and the language runners (`runner.lua` plus `zig.lua`, `mojo.lua`, `odin.lua`, `rust.lua`, and `python.lua`).

### Adding a language
Language support is layered, and each layer is optional depending on what the toolchain provides. Filetype detection is usually native to Neovim; add a treesitter parser to the list in `plugins/treesitter.lua` only when one is bundled. Register a language server in `plugins/lsp.lua` under `mason_servers` when Mason can install it, or `external_servers` when the binary is provided outside Mason — external entries map a server to the executable it spawns and are skipped when that executable is absent, which is what keeps the configuration portable across machines and architectures. That PATH probe runs once, when the first file of the session is opened, so it cannot answer for a server installed per-project; list those in `project_local_servers` instead, which enables them unconditionally and leaves resolution to the server module.

Per-server overrides belong in `lsp/<server>.lua`. These modules are required once and cached, so anything computed at their top level freezes to whichever buffer happened to trigger that load — resolve per-project values through the hooks Neovim calls per client instead. `cmd` as a `fun(dispatchers, config)` receives `config.root_dir` already resolved from `root_markers` and is the only hook that can vary the executable or its environment (`before_init` runs after the process is spawned). `root_dir` as a `fun(bufnr, on_dir)` gates activation: leaving `on_dir` uncalled keeps the server off for that buffer rather than spawning a process that will fail. `lsp/mojo.lua` uses both to find a uv-installed `mojo-lsp-server` and put the Modular libraries on the loader path.

Execution takes one of two forms. Languages with a maintained Jupyter kernel go through `plugins/pyrepl.lua`, where session state is the point. Everything else gets a small module on top of `runner.lua`, registered in the `runner_modules` table in `keymaps.lua`. Those modules supply commands only; `runner.lua` owns the output buffer, process group, and termination. That buffer's filetype is `taskrun`, which is listed in `autocmds.lua` among the filetypes closing with `q`. Implement just the verbs the toolchain actually supports — `run`, `build`, `test`, `test_nearest`, `stop` — because mappings are bound only for functions that exist, and inventing a verb the tool lacks produces a dead key. Prefer resolving a toolchain from the project (`.venv/bin/<tool>`) before `$PATH`, and detect tools with `vim.fn.executable` rather than testing the platform. Verify command flags against the installed binary before writing the module; upstream CLIs change, and guessing has repeatedly produced commands that no longer exist.

## Build, Test, and Development Commands
There is no build step in the usual app sense; changes are synced into `$HOME` and exercised in the real runtime.

- `nvim` bootstraps plugins through `vim.pack` on first launch.
- `nvim +"PackStatus"` shows managed plugin state.
- `nvim +"PackUpdate"` updates plugins registered in `.config/nvim/lua/es/pack.lua`.
- `nvim +"Mason"` opens the Mason UI for LSP/DAP tooling.
- `uv sync --group dev` installs the local Python helpers from `pyproject.toml`.
- `uv run python -m isort .` sorts Python imports when Python files change.

## Coding Style & Naming Conventions
Use Lua for Neovim config and keep modules small and single-purpose. Follow the existing style: 2-space indentation in Lua, snake_case for Lua module filenames, and direct `require("es.plugins.<name>").setup()` wiring from `pack.lua`. Keep plugin responsibilities split cleanly: startup-only UI in `startup`, buffer-driven features behind autocommands, and filetype-specific logic in dedicated handlers.

## Testing Guidelines
Verification is mostly manual because this repo configures interactive tools. Treat this repository as the source of truth; edits here are not live until the user runs their sync scripts from the repo location into the `$HOME` runtime config area. Do not assume changes are present in `~/.config/nvim`, and do not run validation that installs plugins, repairs pack data, or writes into live runtime paths unless explicitly requested. After the user syncs `.config/nvim/` into the runtime area, confirm the relevant command, keymap, or UI path works in a real session. For plugin-loading changes, test both dashboard startup and opening a file. No formal coverage target is defined.

## Commit & Pull Request Guidelines
Recent history mixes conventional and short imperative subjects; prefer concise, scoped commit messages such as `refactor(nvim): initialize mason separately from lazy lsp setup`. Keep each commit focused on one subsystem. PRs should describe the user-visible behavior change, mention any required runtime sync or migration step, and include screenshots only when UI behavior changed.

## Configuration Notes
Do not commit machine-specific secrets or local state. Avoid tracking generated Neovim runtime artifacts such as cache, state, or lockfile churn outside the intended config files.
