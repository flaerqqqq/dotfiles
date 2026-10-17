-- External monitor (primary)
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1200@74.94",
	position = "0x0",
	scale = 1,
})

-- Laptop monitor
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x1200",
	scale = 1,
})

hl.on("hyprland.start", function()
	hl.exec_cmd('bash -c "~/.config/hypr/conf/scripts/lid_monitor.sh"')
end)

-- Lid switch binds
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/conf/scripts/lid_monitor.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/conf/scripts/lid_monitor.sh"), { locked = true })
