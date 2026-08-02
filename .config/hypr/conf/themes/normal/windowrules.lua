-- ~/.config/hypr/conf/themes/normal/windowrules.lua (continued)
-- or its own file (e.g. windowrules_walker.lua) — merge into whichever
-- windowrules.lua you're consolidating into.

-- Rules to make Walker Launcher behave correctly when used as a native
-- Wayland window. Named so it can be toggled/updated at runtime later via
-- someHandle:set_enabled(false) if needed.
hl.window_rule({
	name = "vicinae",
	match = { class = "vicinae" },
	rounding = 20,
	rounding_power = 4,
	float = true,
	pin = true,
	allows_input = true,
	stay_focused = true,
	opacity = 0.95,
})

-- Opacity rules
hl.window_rule({ match = { class = "code" }, opacity = 0.90 })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, opacity = 0.90 })
hl.window_rule({ match = { class = "spotify" }, opacity = 0.80 })
hl.window_rule({ match = { class = "org.telegram.desktop" }, opacity = 0.80 })
hl.window_rule({ match = { class = "Postman" }, opacity = 0.90 })
