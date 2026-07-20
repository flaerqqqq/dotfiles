#!/bin/bash

# 1. Check if Walker is currently mapped (visible)
# We use hyprctl to check the 'mapped' status of the window class
IS_WALKER_OPEN=$(hyprctl clients -j | jq -r '.[] | select(.class == "dev.benz.walker") | .mapped')

if [ "$IS_WALKER_OPEN" == "true" ]; then
  # Hide it via the service toggle so we don't kill the daemon
  walker
  # Small sleep to let the compositor unmap the window before the shot
  sleep 0.1
fi
