# Repository Guidelines

## Project Structure & Module Organization
This repo stores personal editor and shell configuration. The main runtime files are `.config/nvim/` for Neovim, `.vim/` and `.vimrc` for Vim, and `.tmux.conf` for tmux. Neovim Lua code lives under `.config/nvim/lua/es/`: `plugins/` contains plugin setup modules, `lsp/` contains per-server settings, and `pack.lua` defines plugin registration and lazy-loading boundaries.

## Build, Test, and Development Commands
There is no build step in the usual app sense; changes are synced into `$HOME` and exercised in the real runtime.

- `nvim` bootstraps plugins through `vim.pack` on first launch.
- `nvim +"PackStatus"` shows managed plugin state.
- `nvim +"PackUpdate"` updates plugins registered in `.config/nvim/lua/es/pack.lua`.
- `nvim +"Mason"` opens the Mason UI for LSP/DAP tooling.
- `uv sync --group dev` installs the local Python helpers from `pyproject.toml`.
- `python -m isort .` sorts Python imports when Python files change.

## Coding Style & Naming Conventions
Use Lua for Neovim config and keep modules small and single-purpose. Follow the existing style: 2-space indentation in Lua, snake_case for Lua module filenames, and direct `require("es.plugins.<name>").setup()` wiring from `pack.lua`. Keep plugin responsibilities split cleanly: startup-only UI in `startup`, buffer-driven features behind autocommands, and filetype-specific logic in dedicated handlers.

## Testing Guidelines
Verification is mostly manual because this repo configures interactive tools. Treat this repository as the source of truth; edits here are not live until the user runs their sync scripts from the repo location into the `$HOME` runtime config area. Do not assume changes are present in `~/.config/nvim`, and do not run validation that installs plugins, repairs pack data, or writes into live runtime paths unless explicitly requested. After the user syncs `.config/nvim/` into the runtime area, confirm the relevant command, keymap, or UI path works in a real session. For plugin-loading changes, test both dashboard startup and opening a file. No formal coverage target is defined.

## Commit & Pull Request Guidelines
Recent history mixes conventional and short imperative subjects; prefer concise, scoped commit messages such as `refactor(nvim): initialize mason separately from lazy lsp setup`. Keep each commit focused on one subsystem. PRs should describe the user-visible behavior change, mention any required runtime sync or migration step, and include screenshots only when UI behavior changed.

## Configuration Notes
Do not commit machine-specific secrets or local state. Avoid tracking generated Neovim runtime artifacts such as cache, state, or lockfile churn outside the intended config files.
