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

_vim-plugins-install:
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

_vim-plugins-update:
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

_vim-plugins-prune:
  @pack_root="{{ vim_pack_root }}"; \
  case "$pack_root" in \
    ""|/|"$HOME"|"$HOME/"|"$HOME/.vim"|"$HOME/.vim/") \
      printf 'refusing unsafe Vim package root: %s\n' "$pack_root" >&2; \
      exit 1; \
      ;; \
  esac; \
  start_dir="$pack_root/start"; \
  if [ ! -d "$start_dir" ]; then \
    printf 'no Vim package directory at %s\n' "$start_dir"; \
    exit 0; \
  fi; \
  expected_file="$(mktemp)"; \
  stale_file="$(mktemp)"; \
  trap 'rm -f "$expected_file" "$stale_file"' EXIT; \
  while read -r repo; do \
    [ -n "$repo" ] || continue; \
    printf '%s\n' "${repo##*/}"; \
  done <<< "{{ vim_plugins }}" | sort -u > "$expected_file"; \
  while IFS= read -r -d '' dest; do \
    name="${dest##*/}"; \
    if ! grep -Fqx -- "$name" "$expected_file"; then \
      printf '%s\n' "$dest" >> "$stale_file"; \
    fi; \
  done < <(find "$start_dir" -mindepth 1 -maxdepth 1 -type d -print0); \
  if [ ! -s "$stale_file" ]; then \
    printf 'no stale Vim plugins in %s\n' "$start_dir"; \
    exit 0; \
  fi; \
  printf 'stale Vim plugins:\n'; \
  sed 's/^/  /' "$stale_file"; \
  if [ "${VIM_PLUGINS_PRUNE_FORCE:-0}" != 1 ]; then \
    if [ ! -t 0 ]; then \
      printf 'refusing non-interactive prune; set VIM_PLUGINS_PRUNE_FORCE=1 to confirm\n' >&2; \
      exit 1; \
    fi; \
    printf 'Remove these directories? [y/N] '; \
    read -r answer; \
    case "$answer" in y|Y|yes|YES) ;; *) printf 'prune cancelled\n'; exit 0 ;; esac; \
  fi; \
  while IFS= read -r dest; do \
    printf 'removing %s\n' "$dest"; \
    rm -rf -- "$dest"; \
  done < "$stale_file"

_vim-plugins-helptags:
  @vim -Nu NONE -i NONE -n -es +'helptags ALL' +qa

# Install plugins declared in vim_plugins that are not present locally.
vim-plugins-install: _vim-plugins-install _vim-plugins-helptags

# Fast-forward all installed plugins declared in vim_plugins.
vim-plugins-update: _vim-plugins-update _vim-plugins-helptags

# Remove installed package directories not declared in vim_plugins.
vim-plugins-prune: _vim-plugins-prune _vim-plugins-helptags

# Reconcile installed Vim plugins with vim_plugins, then update them.
vim-plugins-sync: _vim-plugins-install _vim-plugins-update _vim-plugins-prune _vim-plugins-helptags

vim-go-binaries:
  @vim -Nu NONE -i NONE -n -es +'packadd vim-go' +'GoUpdateBinaries' +qa
