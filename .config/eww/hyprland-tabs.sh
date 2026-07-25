#!/usr/bin/env bash

#
# Requires: hyprctl, eww, jq, socat
#
# Add to hyprland.conf:
#   exec-once = eww daemon
#   exec-once = ~/.config/eww/hyprland-tabs.sh
#

set -uo pipefail

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/hyprland-tabs.pid"

echo $$ >"$PID_FILE"

hyprctl_json() {
    local raw
    raw=$(hyprctl -j "$@" 2>/dev/null)
    printf '%s' "$raw" | sed -n '/^[{[]/,$p'
}

update_tabs() {
    local monitors_json clients_json active_window_json active_addr mon_names

    monitors_json=$(hyprctl_json monitors)
    clients_json=$(hyprctl_json clients)
    [ -z "$clients_json" ] && clients_json='[]'

    active_window_json=$(hyprctl_json activewindow)
    active_addr=$(printf '%s' "$active_window_json" | jq -r '.address // empty' 2>/dev/null)

    # Get the literal hardware names of the monitors (e.g., "DP-1", "eDP-1")
    mon_names=$(printf '%s' "$monitors_json" | jq -r '.[].name' 2>/dev/null)

    for mon in $mon_names; do
        local ws_id state_file last_file was_open mon_tabs mon_last count

        # Find the active workspace for this specific monitor
        ws_id=$(printf '%s' "$monitors_json" | jq -r ".[] | select(.name == \"$mon\") | .activeWorkspace.id" 2>/dev/null)
        [ -z "$ws_id" ] && continue

        # Track states per hardware name, completely ignoring position or ID
        state_file="${XDG_RUNTIME_DIR:-/tmp}/hyprland-tabs-open-$mon"
        last_file="${XDG_RUNTIME_DIR:-/tmp}/hyprland-tabs-last-$mon"
        [ -f "$state_file" ] || echo 0 >"$state_file"
        [ -f "$last_file" ] || echo "[]" >"$last_file"

        was_open=$(cat "$state_file" 2>/dev/null || echo 0)
        mon_last=$(cat "$last_file" 2>/dev/null || echo "[]")

        # Filter clients specific to this monitor's active workspace
        mon_tabs=$(
            printf '%s' "$clients_json" | jq -c \
                --arg ws "$ws_id" \
                --arg active "$active_addr" '
          [
            .[]
            | select(.workspace.id == ($ws | tonumber))
          ]
          | sort_by(.at[0])
          | map({
              address: .address,
              title: ((.title // .class) | split("\n")[0]),
              class: .class,
              icon: (
                {
                  "jetbrains-idea": "idea",
                  "Postman": "postman",
                  "zen": "zen-browser",
                  "google-chrome": "google-chrome",
                  "kitty": "kitty",
                  "spotify": "spotify",
                  "code": "vscode"
                }[.class] // (.class | ascii_downcase)
              ),
              active: (.address == $active)
            })
        ' 2>/dev/null
        )

        [ -z "$mon_tabs" ] && mon_tabs='[]'

        count=$(printf '%s' "$mon_tabs" | jq 'length' 2>/dev/null)
        [ -z "$count" ] && count=0

        # Pass the hardware name to Eww (e.g., updates variable 'windows_DP-1')
        if [ "$mon_tabs" != "$mon_last" ]; then
            printf '%s' "$mon_tabs" >"$last_file"
            eww update "windows_$mon=$mon_tabs" 2>/dev/null || true
        fi

        # Open or close the specific bar using the hardware name
        if [ "$count" -lt 2 ]; then
            if [ "$was_open" -eq 1 ]; then
                eww close "tabbar_$mon" 2>/dev/null || true
                echo 0 >"$state_file"
            fi
        else
            if [ "$was_open" -eq 0 ]; then
                eww open "tabbar_$mon" 2>/dev/null || true
                echo 1 >"$state_file"
            fi
        fi
    done
}

update_tabs
trap 'update_tabs' USR1

poll_loop() {
    while true; do
        sleep 1.5
        update_tabs
    done
}

poll_loop &
POLL_PID=$!

trap 'kill "$POLL_PID" 2>/dev/null || true; rm -f "$PID_FILE"' EXIT

while read -r line; do
    case "$line" in
    openwindow* | closewindow* | movewindow* | activewindow* | workspace* | createworkspace* | destroyworkspace* | focusedmon* | windowtitle*)
        update_tabs
        ;;
    esac
done < <(socat -U - UNIX-CONNECT:"$SOCK")
