#!/usr/bin/env bash
# Resolve the throwaway Neovim probe root and print its absolute, symlink-free path.
#
# Sole owner of the probe location so every recipe agrees on it, and the sole place
# the safety guard lives. Override with NVIM_PROBE_HOME; defaults under $TMPDIR.
#
# The path is resolved through its parent and validated BEFORE anything is created,
# so a relative or symlinked value can neither slip past the guard nor leave a stray
# directory behind when it is refused.

set -euo pipefail

root=${NVIM_PROBE_HOME:-${TMPDIR:-/tmp}/dotfiles-nvim-probe}
root=${root%/}

refuse() {
  printf 'refusing unsafe Neovim probe root: %s\n' "$1" >&2
  exit 1
}

case $root in
"" | /*/../* | */..) refuse "$root" ;;
esac

parent=$(dirname "$root")
if [ ! -d "$parent" ]; then
  printf 'probe root parent does not exist: %s\n' "$parent" >&2
  exit 1
fi
root="$(cd "$parent" && pwd -P)/$(basename "$root")"
repo=$(cd "$(git rev-parse --show-toplevel)" && pwd -P)

case $root in
/ | "$HOME" | "$HOME"/.config* | "$HOME"/.local* | "$HOME"/.cache* | "$HOME"/.vim* | "$repo" | "$repo"/*)
  refuse "$root"
  ;;
esac

mkdir -p "$root"
printf '%s\n' "$root"
