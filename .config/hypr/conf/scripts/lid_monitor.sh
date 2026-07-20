#!/bin/bash
# Define your laptop monitor name (Verify with `hyprctl monitors`)
LAPTOP_MONITOR="eDP-1"

# Check if lid is open or closed using the path you verified
if grep -q open /proc/acpi/button/lid/*/state; then
  # Lid is OPEN: enable laptop screen
  hyprctl eval "hl.monitor({ output = \"$LAPTOP_MONITOR\", mode = \"preferred\", position = \"0x1200\", scale = 1, disabled = false })"
else
  # Lid is CLOSED: disable laptop screen
  hyprctl eval "hl.monitor({ output = \"$LAPTOP_MONITOR\", disabled = true })"
fi
