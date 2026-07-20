-- ~/.config/hypr/conf/themes/normal/animations.lua

hl.config({
	animations = {
		enabled = true,
	},
})

-- Bezier curves
hl.curve("softSnap", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("slideEase", { type = "bezier", points = { { 0.12, 0 }, { 0.39, 0 } } })
hl.curve("slideWorkspace", { type = "bezier", points = { { 0.4, 0 }, { 0.25, 1 } } })
hl.curve("easy", { type = "spring", mass = 0.6, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("slidevert", { type = "bezier", points = { { 0.4, 0 }, { 0.20, 1 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.0, bezier = "softSnap" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.0, bezier = "softSnap", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "popin 50%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "linear", style = "popin 50%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "slideWorkspace", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.5, bezier = "slideWorkspace", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.5, bezier = "slideWorkspace", style = "slidevert" })
