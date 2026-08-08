#!/usr/bin/env bash
# Containment check: runtime artifacts must never live in this worktree.
#
# Neovim writes these into whatever directory acts as its config root, so one
# appearing here means a process was pointed at the workspace instead of the
# throwaway probe runtime. See "Scope & Deployment Boundaries" in AGENTS.md.
#
# `git status` is the primary signal — these artifacts are deliberately NOT
# gitignored, so an escape shows up as an untracked file. This script is the
# secondary sweep for anything a global excludes file might still be hiding.

set -euo pipefail

# Files only a Neovim process rooted at this worktree can produce. Swap files are
# deliberately absent: a .swp here just means an editor has a repo file open, which
# is normal when the user edits these configs directly.
PATTERNS=(
  nvim-pack-lock.json
  lazy-lock.json
  '*.shada'
  '*.shada.tmp.*'
  .netrwhist
  nvim.log
)

cd "$(git rev-parse --show-toplevel)"

hits=()
while IFS= read -r -d '' path; do
  name=${path##*/}
  for pattern in "${PATTERNS[@]}"; do
    # $pattern is deliberately unquoted so it globs.
    if [[ $name == $pattern ]]; then
      hits+=("${path#./}")
      break
    fi
  done
done < <(find . -path ./.git -prune -o -path ./.vim/pack -prune -o -type f -print0)

if ((${#hits[@]} > 0)); then
  printf 'containment escape — runtime artifacts in worktree:\n' >&2
  printf '  %s\n' "${hits[@]}" >&2
  printf '\nThese are runtime output, not source. Remove them, and run Neovim only\n' >&2
  printf 'through `just nvim-probe` / `just nvim-eval`.\n' >&2
  exit 1
fi

printf 'containment clean\n'
