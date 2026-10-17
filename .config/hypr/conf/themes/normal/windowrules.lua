-- ~/.config/hypr/conf/themes/normal/windowrules.lua (continued)
-- or its own file (e.g. windowrules_walker.lua) — merge into whichever
-- windowrules.lua you're consolidating into.

-- Rules to make Walker Launcher behave correctly when used as a native
-- Wayland window. Named so it can be toggled/updated at runtime later via
-- someHandle:set_enabled(false) if needed.
hl.window_rule({
	name = "vicinae",
	match = { class = "vicinae" },
	float = true,
	pin = true,
	allows_input = true,
	stay_focused = true,
	opacity = 0.95,
})
