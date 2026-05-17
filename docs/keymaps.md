# Keymaps

Leader key is `<Space>`. Shared Vim/Neovim mappings live in `.vim/common.vim`; Neovim-only mappings live in `.config/nvim/lua/es/keymaps.lua`.

## Mental Model
- `g...` is Vim's extended "go/do" namespace.
- `gr...` is Neovim's LSP-related symbol action namespace.
- `[x` / `]x` means previous/next thing of type `x`.
- `[` points backward, previous, or first; `]` points forward, next, or last.
- `d` steps through diagnostics; `D` jumps to the diagnostic boundary.
- `K` keeps its classic "keyword help" role through LSP hover.
- `CTRL-]` keeps its classic tag-jump role through LSP definition.

## Shared Vim And Neovim
These work in both Vim and Neovim.

| Shortcut | Action |
| --- | --- |
| `<Leader>y` | Yank to system clipboard (normal/visual) |
| `<Leader>n` | New split |
| `<Leader>a` | Alternate buffer |
| `<Leader>r` (visual) | Search selection for quick replace |
| `<Leader>k` | Clear last search highlight |
| `<M-.>`, `<M-,>`, `<M-'>`, `<M-;>` | Resize windows |
| `z0` | Set local foldlevel to 99 and refresh folds in Vim |
| `z1` - `z6` | Set local foldlevel 1-6 and refresh folds in Vim |
| `<Leader><Leader>t` | Open bottom terminal helper |
| `<Leader><Esc>` | Exit terminal-mode |

## Neovim Defaults
Built-in Neovim 0.12 mappings used by this config.

| Shortcut | Action |
| --- | --- |
| `K` | Hover |
| `CTRL-]` | Definition through LSP tagfunc |
| `gra` | Code action |
| `gri` | Implementation |
| `grn` | Rename |
| `grr` | References |
| `grt` | Type definition |
| `gO` | Document symbols |
| `<C-s>` (insert) | Signature help |
| `]d` / `[d` | Next/previous diagnostic |
| `]D` / `[D` | First/last diagnostic |

## LSP Extras
Buffer-local LSP mappings that supplement Neovim defaults instead of duplicating them.

| Shortcut | Action |
| --- | --- |
| `<Leader>lc` | Incoming calls |
| `<Leader>lC` | Outgoing calls |
| `<Leader>lD` | Declaration |
| `<Leader>lf` | Format (conform) |
| `<Leader>lw` | Workspace symbols |

## Diagnostics
Diagnostic list and float helpers. Navigation uses Neovim defaults above.

| Shortcut | Action |
| --- | --- |
| `<Leader>df` | Diagnostic float |
| `<Leader>dl` | Diagnostic loclist |
| `<Leader>dq` | Diagnostic quickfix |

## AI
Sidekick manages terminal sessions for installed AI CLIs. NES setup and usage remain in the README.

Typical flow:
1. Use `<Leader>As` to choose an installed CLI.
2. Use `<Leader>Aa` to open or hide the Sidekick terminal.
3. Send context with `<Leader>At`, `<Leader>AF`, or visual `<Leader>Av`.
4. Use `<Leader>Ap` for a one-off prompt with the current context.

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

## Debugging
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

## Find
Telescope pickers use ripgrep for text search and fd for file finding. Hidden file search (`<Leader>fh`) and the directory picker that feeds Oil (`<Leader>fD`) share the same fd exclude list in `.config/nvim/lua/es/keymaps.lua`.

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
| `<M-d>` (buffers picker) | Delete selected buffer and keep picker open |

## Git
Fugitive operations.

| Shortcut | Action |
| --- | --- |
| `<Leader>gg` | Git status |

## Hunks
Gitsigns operations are buffer-local and active only in git files.

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

## Explorer
NvimTree and Oil navigation.

| Shortcut | Action |
| --- | --- |
| `-` | Oil parent directory |
| `<Leader>et` | NvimTree toggle |
| `<Leader>ef` | NvimTree find file |
| `<Leader>ec` | NvimTree close |
| `<Leader>ep` | NvimTree open parent directory |
| `<Leader>eo` | NvimTree open Oil directory |

## Flash
Quick jump navigation. These mappings preserve Vim defaults for `s` and `S`.

| Shortcut | Action |
| --- | --- |
| `<Leader>s` | Flash jump |
| `<Leader>S` | Flash treesitter |
| `r` (operator pending) | Flash remote |
| `R` (operator/visual) | Flash treesitter search |
| `<C-s>` (command mode) | Flash toggle search |

## Other Neovim Mappings
| Shortcut | Action |
| --- | --- |
| `<Leader>mp` | Markdown preview |
| `<Leader><Leader>x` | Save and source current Lua file |
| `z0` | Set window-local foldlevel to 99 and recompute folds |
| `z1` - `z6` | Set window-local foldlevel 1-6 and recompute folds |

## nvim-cmp
| Shortcut | Action |
| --- | --- |
| `<CR>` | Confirm selected completion item |
| `<C-n>` / `<C-p>` | Navigate completion menu |
| `<C-Space>` | Open completion menu |
| `<C-b>` / `<C-f>` | Scroll completion docs; jump previous/next snippet placeholder when a snippet is active |
