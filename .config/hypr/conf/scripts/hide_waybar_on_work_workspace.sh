#!/usr/bin/env bash
set -euo pipefail

HIDDEN_WORKSPACE=2
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hide-waybar.state"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/hide-waybar.lock"

hide() {
  if [[ "$(cat "$STATE_FILE" 2>/dev/null || true)" != "hidden" ]]; then
    pkill -SIGUSR1 waybar
    echo hidden >"$STATE_FILE"
  fi
}

show() {
  if [[ "$(cat "$STATE_FILE" 2>/dev/null || true)" != "shown" ]]; then
    pkill -SIGUSR1 waybar
    echo shown >"$STATE_FILE"
  fi
}

update_state() {
  (
    flock -x 9

    local current_workspace
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

    if [[ "$current_workspace" == "$HIDDEN_WORKSPACE" ]]; then
      hide
    else
      show
    fi
  ) 9>"$LOCK_FILE"
}

echo shown >"$STATE_FILE"

# Initial sync
update_state

# Safety watchdog (waybar restart, wake from suspend, etc.)
(
  while true; do
    sleep 5
    update_state
  done
) &

echo "Listening on $SOCKET"

while IFS= read -r line; do
  case "$line" in
  workspace* | focusedmon* | createworkspace* | destroyworkspace*)
    update_state
    ;;
  esac
done < <(socat -u UNIX-CONNECT:"$SOCKET" -)
