-- ~/.config/hypr/conf/themes/normal/decorations.lua

hl.config({
	decoration = {
		rounding = 16,
		shadow = {
			range = 10,
			render_power = 3,
			color = "rgba(00000050)",
		},
		blur = {
			enabled = true,
			size = 10,
			passes = 3,
			ignore_opacity = true,
			contrast = 1.5,
			new_optimizations = true,
		},
	},
})
