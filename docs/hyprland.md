# Hyprland

Config is Lua under `.config/hypr/`. Each file in `conf/` is symlinked individually, so after adding a new file run `install.sh` (or `ln -s` it into `~/.config/hypr/conf/`) before reloading.

## Layout

- The layout is `scrolling` (`conf/general.lua`): windows are columns on a horizontal strip.
- `Super+D` fits the active column into view, `Super+R` cycles the column width, `Super+'` moves the window out of its column.
- `Super+Shift+H/L` moves the column left/right. `Super+,/.` moves the window to the neighbouring column.
- `Super+Shift+J/K` moves the window up/down inside its column.

## Groups (tabs)

A group puts several windows in one tiled slot with a tab bar (the groupbar) on top. Styling is in `conf/group.lua`.

| Key | Action |
|---|---|
| `Super+G` | Toggle the focused window into or out of a group |
| `Super+]` / `Super+[` | Next / previous tab |
| `Super+Alt+H/J/K/L` | Move the focused window into the group that is in that direction |
| `Super+Shift+[` / `Super+Shift+]` | Move the active tab left / right inside its group (argument unverified) |
| `Super+Alt+G` | Pop the focused window out of its group |

Dragging a window onto a group's tab bar also adds it. `auto_group` is off, so new windows never join a group on their own.

## Workspaces

Switching workspaces slides vertically (`style = "slidevert"` on the `workspaces*` animations in `conf/animations.lua`). The 4-finger horizontal swipe switches workspaces (4-finger up/down is the overview), and `Super+Ctrl+J/K` moves to the next/previous workspace.

## Waybar workspaces

Waybar's built-in `hyprland/workspaces` module sends the legacy `dispatch workspace N`, which Hyprland's Lua config rejects, so clicking did nothing. Both setups (`normal`, `performance`) now use five custom modules, `custom/ws1` to `custom/ws5`:

- `scripts/waybar-workspace N` (linked to `~/.local/bin`) listens to Hyprland's event socket and prints JSON with class `active` (focused), `visible` (shown on another monitor), `occupied` (has windows) or `inactive`. Needs `socat` and `jq`.
- Clicking runs `hyprctl dispatch 'hl.dsp.focus({ workspace = "N" })'`. Scrolling goes to the previous/next workspace.
- Only workspaces 1-5 are shown. To add one, add a `custom/wsN` module and a matching CSS selector in both setups.
