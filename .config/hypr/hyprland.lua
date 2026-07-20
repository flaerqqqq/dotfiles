-- ~/.config/hypr/hyprland.lua
-- Entry point. Each require() is its own Lua "scope" — an error in one
-- file won't stop the others from loading.

-- Defaults
require("conf.env")
require("conf.execs")
require("conf.keybinds")
require("conf.input")
require("conf.misc")
require("conf.monitor")
require("conf.plugins")
require("conf.workspaces")
require("conf.windowrules_general")

-- Active theme
-- NOTE: conf/active_theme is a symlink to conf/themes/normal (or /performance).
-- require() follows the symlink fine, same as `source` did.
require("conf.active_theme.animations")
require("conf.active_theme.decorations")
require("conf.active_theme.general")
require("conf.active_theme.layerrules")
require("conf.active_theme.windowrules")

-- Old config forced Hyprland into a "global" submap on startup via
-- `exec = hyprctl dispatch submap global`, because dispatchers weren't
-- available until the compositor had finished loading. hl.on("hyprland.start", ...)
-- is the proper hook for that now.
--
-- IMPORTANT: this only works if conf/keybinds.lua actually defines a
-- submap called "global" (via hl.define_submap("global", function() ... end))
-- and puts your everyday binds inside it. If your old keybinds.conf just had
-- `submap = global` sitting above a long flat list of `bind = ...` lines with
-- no matching `submap = reset`, that whole list needs to move inside the
-- function body below when we convert keybinds.conf next.
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.submap("global"))
end)
