hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")

	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("dbus-update-activation-environment --all")
	hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	hl.exec_cmd("easyeffects --hide-window --service-mode")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("vicinae server")

	hl.exec_cmd("gsettings set org.gnome.desktop.interface text-scaling-factor 1.00")
	hl.exec_cmd("gsettings set org.gnome.desktop.wm.preferences button-layout ':'")

	-- TODO: see note above re: $qsConfig — this is currently broken as literal text.
	hl.exec_cmd(
		"wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)
	hl.exec_cmd(
		"wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
	)

	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("1password --silent")

	hl.exec_cmd("elephant service enable")
	hl.exec_cmd("systemctl --user start elephant.service")
	hl.exec_cmd("walker --gapplication-service")
end)
