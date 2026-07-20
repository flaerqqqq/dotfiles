-- ~/.config/hypr/conf/input.lua

-- ========== GESTURES (1:1 trackpad gestures) ==========
-- This is the newer per-gesture system (hl.gesture), separate from the
-- gestures{} gesture category below (workspace-swipe tuning).
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 3, direction = "pinch", action = "float" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- TODO: `dispatcher, global, quickshell:overviewToggle` in old hyprlang calls
-- Hyprland's "global" dispatcher (sends a GlobalShortcuts-style request,
-- e.g. to quickshell) with the shortcut name as its argument. I couldn't
-- find hl.dsp.global() confirmed in the current docs/stubs — verify against
-- your installed hl.meta.lua stub (or `hyprctl repl 'hl.dsp'` to inspect
-- available fields) before relying on this exactly as written.
hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.dispatch(hl.dsp.global("quickshell:overviewToggle"))
	end,
})
hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.global("quickshell:overviewClose"))
	end,
})

-- ========== GESTURES (workspace swipe tuning) ==========
hl.config({
	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.2,
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true,
	},
})

-- ========== INPUT ==========
-- NOTE: your original set kb_layout twice ("us", then later "us,ua"). In
-- hyprlang the second assignment wins, so only the final value is kept
-- here — flagging in case the first "us" was meant to be a fallback rather
-- than an accidental overwrite.
hl.config({
	input = {
		float_switch_override_focus = 0,
		repeat_delay = 250,
		repeat_rate = 35,
		sensitivity = -0.5,
		follow_mouse = 1,
		off_window_axis_events = 2,
		kb_layout = "us,ua",
		kb_options = "grp:alt_shift_toggle",
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.2,
		},
	},
})

-- ========== PER-DEVICE OVERRIDE ==========
hl.device({
	name = "syna32b3:01-06cb:ce7d-touchpad",
	sensitivity = 0.0,
})

-- ========== CURSOR ==========
hl.config({
	cursor = {},
})
