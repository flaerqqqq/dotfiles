-- ~/.config/hypr/conf/env.lua

-- ############ Wayland #############
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- ######### Applications #########
hl.env(
	"XDG_DATA_DIRS",
	"$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
)

-- ############ Themes #############
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "Hyprland")
hl.env("XDG_MENU_PREFIX", "Hyprland-")

-- NOTE: these two used `env = VAR=value` (no comma) in your original,
-- unlike every other line here which used the standard `env = VAR,value`
-- comma form. I couldn't confirm whether hyprlang's env directive actually
-- accepts the no-comma `VAR=value` shorthand, or whether these two were
-- silently parsed as a single (harmless, no-op) variable literally named
-- "XDG_CURRENT_DESKTOP=Hyprland" and "GDK_BACKEND=wayland" — i.e. possibly
-- already broken in your old config too. Converted here assuming the
-- intended value, since that's almost certainly what you meant either way.
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland")

-- ######## Virtual environment #########
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", "~/.local/state/quickshell/.venv")

-- ######## Terminal application #########
hl.env("TERMINAL", "kitty -1")
