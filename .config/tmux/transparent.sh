#!/usr/bin/env bash
# Replace the theme background with the terminal default so Ghostty opacity shows through.
bg=$(tmux show -gv @ukiyo-color-bg-bar)
[ -n "$bg" ] || exit 0
for opt in status-style status-left status-right window-status-format window-status-separator; do
  tmux set -g "$opt" "$(tmux show -gv "$opt" | sed "s/bg=$bg/bg=default/g")"
done
tmux set -g popup-style "bg=default"
