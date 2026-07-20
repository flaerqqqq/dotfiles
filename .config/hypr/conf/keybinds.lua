-- ~/.config/hypr/conf/keybinds.lua

local terminal = "kitty"
local fileManager = "kitty -e yazi"
local browser = "google-chrome"
local codeEditor = "idea"
local bluetoothTool = "blueman-manager"
local soundTool = "pavucontrol"
local networkTool = "kitty -e nmtui"
local textEditor = "kitty -e nvim"

local mainMod = "SUPER"
local SUPER_ALT = "SUPER + ALT"
local SUPER_SHIFT = "SUPER + SHIFT"
local SUPER_CTRL = "SUPER + CTRL"
local SUPER_CTRL_SHIFT = "SUPER + CTRL + SHIFT"
local SUPER_CTRL_ALT = "SUPER + CTRL + ALT"

-- Old hyprland.conf had `submap = global` sitting above this entire file with
-- no matching `submap = reset`, meaning every one of these binds lived inside
-- a submap called "global" that hyprland.conf force-activated on startup.
-- hl.define_submap() reproduces that scope; hyprland.lua's
-- hl.on("hyprland.start", ...) hook activates it.
hl.define_submap("global", function()
	-- ========== WORKSPACES ==========
	-- Navigation between workspaces
	for i = 1, 9 do
		hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
	end
	hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "0" }))

	-- Toggle special workspace
	hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

	-- Scroll workspaces with mouse
	hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
	hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

	-- Move to next/previous workspace (relative, wrapping)
	hl.bind(SUPER_CTRL .. " + J", hl.dsp.focus({ workspace = "+1" }))
	hl.bind(SUPER_CTRL .. " + K", hl.dsp.focus({ workspace = "-1" }))

	-- ========== WINDOWS ==========
	hl.bind(mainMod .. " + Q", hl.dsp.window.close())
	hl.bind(SUPER_SHIFT .. " + F", hl.dsp.window.fullscreen())
	-- TODO: "layoutmsg, fit active" is a hyprscrolling-plugin message (see
	-- github.com/hyprwm/hyprland-plugins/hyprscrolling). hl.dsp.layout(msg)
	-- is the generic "send a message to the active layout" dispatcher used
	-- for both the builtin scrolling layout and hyprscrolling in the wiki
	-- examples — verify this still routes to the plugin once you've
	-- confirmed how the plugin registers itself under Lua (conf/plugins.lua).
	hl.bind(mainMod .. " + D", hl.dsp.layout("fit active"))

	-- Alt + Tab cycle windows (MRU order)
	-- TODO: verify the option name for "hist" — likely `history = true`,
	-- unconfirmed against the current hl.dsp.window.cycle_next() signature.
	hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ history = true }))

	-- Super + Tab cycle workspaces
	hl.bind(mainMod .. " + Tab", hl.dsp.focus({ monitor = "+1" }))

	-- Move, resize with mouse
	hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

	-- Resize columns for scrolling layout (hyprscrolling)
	hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))

	-- Window toggle floating
	hl.bind(SUPER_ALT .. " + Space", hl.dsp.window.float({ action = "toggle" }))

	-- Window focus
	hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
	hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
	hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
	hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

	-- Move window from column to column L-R
	hl.bind(mainMod .. " + Comma", hl.dsp.window.move({ direction = "l" }))
	hl.bind(mainMod .. " + Period", hl.dsp.window.move({ direction = "r" }))

	-- Move window U-D inside column
	hl.bind(SUPER_SHIFT .. " + K", hl.dsp.window.move({ direction = "u" }))
	hl.bind(SUPER_SHIFT .. " + J", hl.dsp.window.move({ direction = "d" }))

	-- Move column L-R (hyprscrolling) + refresh eww tabs widget
	hl.bind(SUPER_SHIFT .. " + H", function()
		hl.dispatch(hl.dsp.layout("swapcol l"))
		hl.dispatch(hl.dsp.exec_cmd("~/.config/eww/hyprland-tabs-refresh.sh"))
	end)
	hl.bind(SUPER_SHIFT .. " + L", function()
		hl.dispatch(hl.dsp.layout("swapcol r"))
		hl.dispatch(hl.dsp.exec_cmd("~/.config/eww/hyprland-tabs-refresh.sh"))
	end)

	-- Move window out of column (hyprscrolling)
	hl.bind(mainMod .. " + Apostrophe", hl.dsp.layout("promote"))

	-- Move window to next/previous workspace
	hl.bind(SUPER_CTRL_SHIFT .. " + J", hl.dsp.window.move({ workspace = "+1" }))
	hl.bind(SUPER_CTRL_SHIFT .. " + K", hl.dsp.window.move({ workspace = "-1" }))

	-- Move window to next/previous workspace, silently
	-- TODO: verify the "silent" field name on hl.dsp.window.move — unconfirmed.
	hl.bind(SUPER_CTRL_ALT .. " + J", hl.dsp.window.move({ workspace = "+1", silent = true }))
	hl.bind(SUPER_CTRL_ALT .. " + K", hl.dsp.window.move({ workspace = "-1", silent = true }))

	-- Move window to workspace
	for i = 1, 9 do
		hl.bind(SUPER_SHIFT .. " + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
	end
	hl.bind(SUPER_SHIFT .. " + 0", hl.dsp.window.move({ workspace = "10" }))

	-- Move window to special workspace
	hl.bind(SUPER_ALT .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

	-- Move window to workspace, silently
	for i = 1, 9 do
		hl.bind(SUPER_ALT .. " + " .. i, hl.dsp.window.move({ workspace = tostring(i), silent = true }))
	end
	hl.bind(SUPER_ALT .. " + 0", hl.dsp.window.move({ workspace = "10", silent = true }))
	-- NOTE: original config bound SUPER_ALT + S twice — once above (non-silent
	-- move to special:magic) and once here (silent). The second bind wins at
	-- runtime; this duplicate existed in your old config too, carried over
	-- as-is rather than silently "fixed".
	hl.bind(SUPER_ALT .. " + S", hl.dsp.window.move({ workspace = "special:magic", silent = true }))

	-- ========== MEDIA CONTROL ==========
	-- Brightness
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true, repeating = true })
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })

	-- Volume
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })
	hl.bind(
		"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioLowerVolume",
		hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
		{ locked = true, repeating = true }
	)

	-- Microphone mute
	hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

	-- Next/previous audio
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

	-- Pause/resume audio
	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

	-- ========== APPLICATIONS ==========
	-- Application launcher
	-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("walker"))
	--hl.bind(
	--mainMod .. " + SPACE",
	--hl.dsp.exec_cmd("rofi -show drun -theme /home/vitalii_v/.config/rofi/launchers/type-1/style-14.rasi")
	--)
	hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae open"))

	-- Clipboard
	hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))
	-- Files
	hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("walker -m files"))

	-- Terminal
	hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

	-- File manager
	hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

	-- Browser
	hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))

	-- Code editor
	hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(codeEditor))

	-- Bluetooth tool
	hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(bluetoothTool))

	-- Network tool
	hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(networkTool))

	-- Sound control tool
	hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(soundTool))

	-- Text editor
	hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(textEditor))

	-- tmux attach
	hl.bind(SUPER_SHIFT .. " + RETURN", hl.dsp.exec_cmd("kitty -e tmux new-session -A -s main"))

	-- ========== CONFIG ==========
	-- Reload waybar config
	hl.bind(SUPER_SHIFT .. " + W", hl.dsp.exec_cmd("pkill waybar; waybar"))

	-- Toggle mode
	hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("walker -m menus:controlpanel"))

	-- ========== SCREENSHOT ==========
	-- Screenshot region
	hl.bind("SHIFT + PRINT", function()
		hl.dispatch(hl.dsp.exec_cmd("~/.config/hypr/conf/scripts/hide_walker_if_open.sh"))
		hl.dispatch(hl.dsp.exec_cmd("hyprshot -m window"))
	end)

	-- Screenshot window
	hl.bind("PRINT", function()
		hl.dispatch(hl.dsp.exec_cmd("~/.config/hypr/conf/scripts/hide_walker_if_open.sh"))
		hl.dispatch(hl.dsp.exec_cmd("hyprshot -m region"))
	end)
end)
