#!/usr/bin/env bash

# Set the directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Check if the directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Change" "Directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Generate a list of wallpapers
wallpapers=("$WALLPAPER_DIR"/*.{jpg,jpeg,png})

# Check if wallpapers exist
if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send "Wallpaper Change" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Format wallpapers list for Rofi with icon previews
wallpaper_list=""
for wallpaper in "${wallpapers[@]}"; do
    filename=$(basename "$wallpaper")
    wallpaper_list+="$filename\x00icon\x1f$wallpaper\n"
done

# Use Rofi to select a wallpaper with preview
selected_wallpaper=$(echo -e "$wallpaper_list" | rofi -dmenu -theme-str 'element-icon { size: 150px; }' -p "Select Wallpaper" -theme "~/.config/rofi/launchers/type-2/style-13.rasi")

# If no selection was made, exit
if [ -z "$selected_wallpaper" ]; then
    exit 0
fi

# Apply the selected wallpaper
swww img "$WALLPAPER_DIR/$selected_wallpaper" --transition-type=random

# Notify the user
notify-send "Wallpaper Changed" "New wallpaper set: $selected_wallpaper"

