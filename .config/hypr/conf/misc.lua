-- ~/.config/hypr/conf/misc.lua

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = true,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		allow_session_lock_restore = true,
		session_lock_xray = true,
		initial_workspace_tracking = false,
		-- DO NOT set to true, used to keep focus on floating windows when
		-- other application is opened and request it
		focus_on_activate = false,
		always_follow_on_dnd = true,
	},
})
