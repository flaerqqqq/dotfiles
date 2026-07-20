#!/usr/bin/env bash
#
# install.sh — symlink every file in this dotfiles repo into $HOME,
# preserving the same relative path.
#
# Usage:
#   ./install.sh                          # link everything
#   ./install.sh --dry-run                # just print what would happen
#   ./install.sh --only nvim,zsh          # link ONLY these top-level dirs/files
#   ./install.sh --only nvim --dry-run    # combine flags in any order
#
# Repo layout expected (mirrors $HOME):
#   dotfiles/
#     .bashrc
#     .gitconfig
#     .config/nvim/init.lua
#     .config/starship.toml
#
set -euo pipefail

# Directory this script lives in (i.e. the dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
DRY_RUN=false
ONLY=() # if non-empty, ONLY these top-level paths (relative to repo root) get linked

# --- parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  --only)
    IFS=',' read -r -a ONLY <<<"$2"
    shift 2
    ;;
  *)
    echo "Unknown argument: $1" >&2
    exit 1
    ;;
  esac
done

# Things inside the repo we never want to treat as dotfiles
EXCLUDE=(".git" ".gitignore" "install.sh" "README.md" "LICENSE" "screenshots")

is_excluded() {
  local rel="$1"
  for ex in "${EXCLUDE[@]}"; do
    [[ "$rel" == "$ex" || "$rel" == "$ex"/* ]] && return 0
  done
  return 1
}

# If --only was given, a file is allowed only when its relative path
# starts with (or exactly matches) one of the requested entries.
is_allowed_by_only() {
  local rel="$1"
  # No filter set -> everything is allowed
  [[ ${#ONLY[@]} -eq 0 ]] && return 0

  for want in "${ONLY[@]}"; do
    # trim possible whitespace around comma-separated entries
    want="$(echo "$want" | xargs)"
    [[ "$rel" == "$want" || "$rel" == "$want"/* ]] && return 0
  done
  return 1
}

link_file() {
  local src="$1"                      # absolute path to file in repo
  local rel="${src#"$DOTFILES_DIR"/}" # path relative to repo root
  local dest="$TARGET_DIR/$rel"

  if is_excluded "$rel"; then
    return 0
  fi
  if ! is_allowed_by_only "$rel"; then
    return 0
  fi

  local dest_parent
  dest_parent="$(dirname "$dest")"

  if $DRY_RUN; then
    echo "[dry-run] would link: $dest -> $src"
    return
  fi

  mkdir -p "$dest_parent"

  # If something already exists at the destination and isn't already
  # the correct symlink, back it up instead of clobbering it.
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "already linked: $dest"
      return
    fi
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    echo "backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  echo "linked: $dest -> $src"
}

# Find every regular file in the repo (skip directories, they're implied)
while IFS= read -r -d '' file; do
  link_file "$file"
done < <(find "$DOTFILES_DIR" -type f -print0)

if $DRY_RUN; then
  echo "Dry run complete. Re-run without --dry-run to apply."
fi

exit 0
