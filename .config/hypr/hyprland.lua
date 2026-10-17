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

hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.submap("global"))
end)
