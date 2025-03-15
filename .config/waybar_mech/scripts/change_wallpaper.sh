#!/bin/bash

# Define the wallpaper directory here
WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
# File to keep track of the current wallpaper index
INDEX_FILE="$HOME/Pictures/wallpapers/w006.jpg"

# Ensure swww is running
swww query || swww init

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Directory '$WALLPAPER_DIR' does not exist."
  exit 1
fi

# Get a list of image files in the directory
wallpapers=("$WALLPAPER_DIR"/*.{jpg,jpeg,png})
wallpaper_count=${#wallpapers[@]}

# If there are no images, exit
if [ $wallpaper_count -eq 0 ]; then
  echo "Error: No images found in '$WALLPAPER_DIR'."
  exit 1
fi

# Initialize or update the current index
if [ ! -f "$INDEX_FILE" ]; then
  echo 0 > "$INDEX_FILE"
fi

# Read and increment the current index
index=$(<"$INDEX_FILE")
index=$((index % wallpaper_count))
next_index=$(( (index + 1) % wallpaper_count ))

# Set the wallpaper
swww img "${wallpapers[index]}"

# Update the index for the next run
echo "$next_index" > "$INDEX_FILE"

