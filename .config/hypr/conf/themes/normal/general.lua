-- ~/.config/hypr/conf/themes/normal/general.lua

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 4,
		border_size = 1,
		["col.active_border"] = "rgba(3a3a3aaa)",
		["col.inactive_border"] = "rgba(2a2a2aaa)",
		resize_on_border = true,
		no_focus_fallback = true,
		allow_tearing = false,
		layout = "scrolling",
	},
	scrolling = {
		column_width = 1,
		direction = "right",
		follow_focus = true,
		follow_min_visible = 0.6,
		explicit_column_widths = "0.5,0.75,1.0",
	},
	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
		window_direction_monitor_fallback = false,
	},
})
