set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

vim_pack_root := env_var_or_default("VIM_PACK_ROOT", env_var("HOME") + "/.vim/pack/plugins")

vim_plugins := '''
tpope/vim-surround
tpope/vim-unimpaired
tpope/vim-fugitive
airblade/vim-gitgutter
fatih/vim-go
github/copilot.vim
terrastruct/d2-vim
'''

default:
  @just --list

vim-plugin-dir:
  @printf '%s\n' "{{ vim_pack_root }}/start"

vim-plugins-install:
  @mkdir -p "{{ vim_pack_root }}/start"
  @while read -r repo; do \
    [ -n "$repo" ] || continue; \
    name="${repo##*/}"; \
    dest="{{ vim_pack_root }}/start/$name"; \
    if [ -d "$dest/.git" ]; then \
      printf 'exists %s\n' "$dest"; \
    else \
      git clone "https://github.com/$repo" "$dest"; \
    fi; \
  done <<< "{{ vim_plugins }}"
  @vim -Nu NONE -i NONE -n -es +'helptags ALL' +qa

vim-plugins-update:
  @while read -r repo; do \
    [ -n "$repo" ] || continue; \
    name="${repo##*/}"; \
    dest="{{ vim_pack_root }}/start/$name"; \
    if [ -d "$dest/.git" ]; then \
      printf 'updating %s\n' "$dest"; \
      git -C "$dest" pull --ff-only; \
    else \
      printf 'missing %s\n' "$dest"; \
    fi; \
  done <<< "{{ vim_plugins }}"
  @vim -Nu NONE -i NONE -n -es +'helptags ALL' +qa

vim-go-binaries:
  @vim -Nu NONE -i NONE -n -es +'packadd vim-go' +'GoUpdateBinaries' +qa
