#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/walker_wallpapers"

# Create the cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Loop through all images
for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,JPG,PNG,JPEG,WEBP}; do
  # Skip if no files found
  [ -f "$img" ] || continue

  filename=$(basename "$img")
  thumb="$CACHE_DIR/$filename"

  # If the thumbnail doesn't exist yet, generate it!
  # This creates a perfect 500x500 square, cropping the center to avoid stretched/ugly images.
  if [ ! -f "$thumb" ]; then
    magick "$img" -thumbnail 500x500^ -gravity center -extent 500x500 "$thumb"
  fi
done
