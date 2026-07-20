-- ~/.config/hypr/conf/themes/normal/windowrules.lua

-- Multiple old lines targeting the SAME selector (e.g. "center on" then
-- "float on" for the same title regex) are merged into one hl.window_rule()
-- call each, since that's the documented shape (one match table + as many
-- effect fields as you want per call), rather than issuing N calls for the
-- same selector.

-- ========== Floating: file dialogs ==========
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true, float = true })
hl.window_rule({
	match = { title = "^(Choose wallpaper)(.*)$" },
	center = true,
	float = true,
	size = { "monitor_w*.60", "monitor_h*.65" },
})
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, center = true, float = true })

-- ========== Floating: specific apps ==========
hl.window_rule({ match = { class = "^(blueberry\\.py)$" }, float = true })
hl.window_rule({ match = { class = "^(guifetch)$" }, float = true }) -- FlafyDev/guifetch

hl.window_rule({
	match = { class = "^(pavucontrol)$" },
	float = true,
	size = { "monitor_w*.45", "monitor_h*.45" },
	center = true,
})
hl.window_rule({
	match = { class = "^(org.pulseaudio.pavucontrol)$" },
	float = true,
	size = { "monitor_w*.45", "monitor_h*.45" },
	center = true,
})
hl.window_rule({
	match = { class = "^(nm-connection-editor)$" },
	float = true,
	size = { "monitor_w*.45", "monitor_h*.45" },
	center = true,
})

hl.window_rule({ match = { class = ".*plasmawindowed.*" }, float = true })
hl.window_rule({ match = { class = "kcm_.*" }, float = true })
hl.window_rule({ match = { class = ".*bluedevilwizard" }, float = true })
hl.window_rule({ match = { title = ".*Welcome" }, float = true })
hl.window_rule({ match = { title = "^(illogical-impulse Settings)$" }, float = true })
hl.window_rule({ match = { title = ".*Shell conflicts.*" }, float = true })

hl.window_rule({
	match = { class = "org.freedesktop.impl.portal.desktop.kde" },
	float = true,
	size = { "monitor_w*.60", "monitor_h*.65" },
})
hl.window_rule({
	match = { class = "^(Zotero)$" },
	float = true,
	size = { "monitor_w*.45", "monitor_h*.45" },
})

-- ========== Picture-in-Picture ==========
hl.window_rule({
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	keep_aspect_ratio = true,
	move = { "monitor_w*.73", "monitor_h*.72" },
	size = { "monitor_w*.25", "monitor_h*.25" },
	pin = true,
})

-- ========== Screen sharing ==========
hl.window_rule({
	match = { title = ".*is sharing (a window|your screen).*" },
	float = true,
	pin = true,
	move = { "monitor_w*.5-window_w*.5", "monitor_h-window_h-12" },
})

-- ========== Tearing ==========
hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" }, immediate = true })

-- ========== Fix JetBrains IDEs focus/rerendering problem ==========
-- NOTE: original combined three match props on one line: match:class,
-- match:float (a boolean PROP, matches windows already floating — not an
-- effect), and match:title against an empty/whitespace/"winNNN" title.
-- All three go in the same `match` table since all props must match together.
hl.window_rule({
	match = {
		class = "^jetbrains-.*$",
		float = true,
		title = "^$|^\\s$|^win\\d+$",
	},
	no_initial_focus = true,
})
