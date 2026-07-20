-- ~/.config/hypr/conf/themes/normal/layerrules.lua

-- waybar
hl.layer_rule({
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.2,
})

-- rofi
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.2,
	animation = "fade",
})

-- gtk4-layer-shell
hl.layer_rule({
	match = { namespace = "gtk4-layer-shell" },
	blur = true,
	ignore_alpha = 0.2,
})

-- vicinae
hl.layer_rule({
	match = { namespace = "vicinae" },
	blur = true,
	ignore_alpha = 0.2,
})

-- notifications
hl.layer_rule({
	match = { namespace = "notifications" },
	blur = true,
	ignore_alpha = 0.2,
})

-- NOTE: this is "gtk-layer-shell", not "gtk4-layer-shell" above — a
-- different namespace, kept separate exactly as your original had it
-- (worth double-checking whether that was intentional or a typo upstream).
hl.layer_rule({
	match = { namespace = "gtk-layer-shell" },
	animation = "slide",
	blur = true,
	ignore_alpha = 0.2,
})

-- Named rule, so it can be toggled at runtime later via
-- someHandle:set_enabled(false) if needed.
hl.layer_rule({
	name = "no_anim_for_selection",
	match = { namespace = "selection" },
	no_anim = true,
})
