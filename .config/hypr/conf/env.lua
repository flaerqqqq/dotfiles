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

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland")

-- ######## Virtual environment #########
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", "~/.local/state/quickshell/.venv")

-- ######## Terminal application #########
hl.env("TERMINAL", "kitty -1")
