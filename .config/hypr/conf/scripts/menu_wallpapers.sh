#!/usr/bin/env bash

# Define where you keep your wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Create the directory if it doesn't exist yet
mkdir -p "$WALLPAPER_DIR"

OPTIONS=""

# Loop through all images and format them for Rofi previews
while IFS= read -r file; do
  filename=$(basename "$file")
  OPTIONS+="$filename\0icon\x1f$file\n"
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f -iregex '.*\.\(jpg\|jpeg\|png\|gif\|webp\)' | sort)

# Launch Rofi with a horizontal layout override
# Changed listview to 'layout: horizontal', widened the window, and bumped up the image size
CHOICE=$(echo -en "$OPTIONS" | rofi -dmenu -i -p "Select Wallpaper:" \
  -show-icons \
  -theme-str '
        window { width: 90%; }
        listview { layout: horizontal; spacing: 20px; }
        element { orientation: vertical; padding: 15px; }
        element-icon { size: 350px; horizontal-align: 0.5; }
        element-text { horizontal-align: 0.5; }
    ')

# Handle the choice
case "$CHOICE" in
"")
  # Exit silently if the user hits Escape
  exit 0
  ;;
*)
  # Apply the wallpaper if a valid file was selected
  if [[ -f "$WALLPAPER_DIR/$CHOICE" ]]; then
    swww img "$WALLPAPER_DIR/$CHOICE" \
      --transition-fps 60 \
      --transition-type simple \
      --transition-duration 1

    notify-send "Wallpaper" "Applied $CHOICE"
  else
    notify-send "Error" "Wallpaper not found."
  fi
  ;;
esac
