#!/usr/bin/env bash
#
# install.sh — symlink every file in this dotfiles repo into $HOME,
# with files inside `scripts/` linked flatly into ~/.local/bin/.
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
DRY_RUN=false
ONLY=()

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

EXCLUDE=(".git" ".gitignore" "install.sh" "README.md" "LICENSE" "screenshots")

is_excluded() {
    local rel="$1"
    for ex in "${EXCLUDE[@]}"; do
        if [[ "$rel" == "$ex" ]]; then
            return 0
        fi
        if [[ "$rel" == "$ex"/* ]]; then
            return 0
        fi
    done
    return 1
}

is_allowed_by_only() {
    local rel="$1"
    if [[ ${#ONLY[@]} -eq 0 ]]; then
        return 0
    fi

    for want in "${ONLY[@]}"; do
        want="$(echo "$want" | xargs)"
        if [[ "$rel" == "$want" ]]; then
            return 0
        fi
        if [[ "$rel" == "$want"/* ]]; then
            return 0
        fi
    done
    return 1
}

create_symlink() {
    local src="$1"
    local dest="$2"

    local dest_parent
    dest_parent="$(dirname "$dest")"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[dry-run] would link: $dest ->$src"
        return
    fi

    mkdir -p "$dest_parent"

    local target_exists=0
    if [[ -e "$dest" ]]; then
        target_exists=1
    fi
    if [[ -L "$dest" ]]; then
        target_exists=1
    fi

    if [[ "$target_exists" -eq 1 ]]; then
        local is_same_link=0
        if [[ -L "$dest" ]]; then
            if [[ "$(readlink "$dest")" == "$src" ]]; then
                is_same_link=1
            fi
        fi

        if [[ "$is_same_link" -eq 1 ]]; then
            echo "already linked: $dest"
            return
        fi

        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        echo "backing up existing $dest ->$backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    echo "linked: $dest ->$src"
}

link_file() {
    local src="$1"
    local rel="${src#"$DOTFILES_DIR"/}"

    if is_excluded "$rel"; then
        return 0
    fi
    if ! is_allowed_by_only "$rel"; then
        return 0
    fi

    if [[ "$rel" == scripts/* ]]; then
        local filename
        filename="$(basename "$src")"
        local dest="$TARGET_DIR/.local/bin/$filename"
        create_symlink "$src" "$dest"
        return 0
    fi

    local dest="$TARGET_DIR/$rel"
    create_symlink "$src" "$dest"
}

while IFS= read -r -d '' file; do
    link_file "$file"
done < <(find "$DOTFILES_DIR" -type f -print0)

if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry run complete. Re-run without --dry-run to apply."
fi

exit 0
