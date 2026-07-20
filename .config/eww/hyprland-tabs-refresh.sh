#!/usr/bin/env bash
#
# hyprland-tabs-refresh.sh
# Signals the running hyprland-tabs.sh daemon to refresh immediately.
# Chain this onto any keybind that reorders/moves windows so the tab
# bar updates instantly instead of waiting for the next poll tick.
#
# Example hyprland.conf binds:
#   bind = $mainMod, comma, layoutmsg, swapcol l
#   bind = $mainMod, comma, exec, ~/.config/eww/hyprland-tabs-refresh.sh
#   bind = $mainMod, period, layoutmsg, swapcol r
#   bind = $mainMod, period, exec, ~/.config/eww/hyprland-tabs-refresh.sh

PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/hyprland-tabs.pid"

if [ -f "$PID_FILE" ]; then
  kill -USR1 "$(cat "$PID_FILE")" 2>/dev/null
fi
