-- ~/.config/hypr/conf/execs.lua

-- All of these were `exec-once` (run exactly once, ever), which maps
-- directly onto hl.on("hyprland.start", ...) — unlike the plain `exec =`
-- case in monitor.lua, there's no re-run-on-reload behavior to preserve
-- here, so wrapping the whole block in one listener is a faithful 1:1.
--
-- TODO: `$qsConfig` in the cliphist lines is a hyprlang config variable
-- (not a shell env var — it's inside single-quoted bash -c strings, so the
-- shell itself won't expand it; hyprlang would have substituted it
-- textually before exec-once ever ran). I don't have conf/env.conf yet to
-- know where `$qsConfig` was defined or what it holds. Once you send that
-- file, this needs a `local qsConfig = "..."` (either defined here, or
-- `require()`d from wherever env.conf becomes env.lua) and the two
-- `wl-paste` lines below rewritten to concatenate it in with `..` instead
-- of relying on `$qsConfig` text substitution, since Lua doesn't do that
-- kind of interpolation. Left as literal "$qsConfig" text for now so
-- nothing is silently wrong — this WILL NOT resolve correctly as-is.
hl.on("hyprland.start", function()
	-- Bar, wallpaper
	hl.exec_cmd("waybar")

	-- Core components (authentication, lock screen, notification daemon)
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("dbus-update-activation-environment --all")
	hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- Audio
	hl.exec_cmd("easyeffects --hide-window --service-mode")
	hl.exec_cmd("eww daemon")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("vicinae server")
	hl.exec_cmd("~/.config/eww/hyprland-tabs.sh")

	-- Gnome interface scaling
	hl.exec_cmd("gsettings set org.gnome.desktop.interface text-scaling-factor 1.10")

	-- Clipboard: history
	-- TODO: see note above re: $qsConfig — this is currently broken as literal text.
	hl.exec_cmd(
		"wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)
	hl.exec_cmd(
		"wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)

	-- Polkit
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("1password --silent")

	-- Walker Launcher
	hl.exec_cmd("elephant service enable")
	hl.exec_cmd("systemctl --user start elephant.service")
	hl.exec_cmd("walker --gapplication-service")
end)
