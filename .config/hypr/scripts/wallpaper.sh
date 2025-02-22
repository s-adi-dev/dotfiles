#!/bin/bash

#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# ----------------------------------------------------- 
# Check to use wallpaper cache
# ----------------------------------------------------- 

# Variables
output_dir="$HOME/.cache/wallpaper"
default_wallpaper="$output_dir/default_wallpaper.png"
squarewallpaper="$output_dir/square_wallpaper.png"
blurred_wallpaper="$output_dir/blurred_wallpaper.png"
blur="50x30"
resize_percentage="70%"
square_blur="5x3"  # Subtle blur for the square wallpaper

# ----------------------------------------------------- 
# Checking Arguments
# ----------------------------------------------------- 

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Error: No wallpaper path provided."
  echo "Usage: $0 <path_to_wallpaper>"
  exit 1
fi

# Get the selected wallpaper from the argument
wallpaper="$1"

# Check if the wallpaper file exists
if [ ! -f "$wallpaper" ]; then
    echo "Error: File does not exist: $wallpaper"
    exit 1
fi

# Check if waypaper is running if yes then close it
if pgrep -x "waypaper" > /dev/null; then
  killall waypaper
  pkill waypaper
fi

# Ensure the output directory exists
mkdir -p "$output_dir"

# ----------------------------------------------------- 
# Pywal
# -----------------------------------------------------
echo ":: Execute pywal with $wallpaper"
wal -q -i "$wallpaper"

# ----------------------------------------------------- 
# Pywalfox
# -----------------------------------------------------
if type pywalfox > /dev/null 2>&1; then
    pywalfox update
fi

# ----------------------------------------------------- 
# Generate Blurred Wallpaper in Parallel
# -----------------------------------------------------

echo ":: Generating blurred wallpaper with blur strength $blur..."
magick convert "$wallpaper" -resize "$resize_percentage" -blur "$blur" "$blurred_wallpaper" &
blurred_pid=$!
echo ":: Generating blurred wallpaper in the background..."

# ----------------------------------------------------- 
# Create Reduced-Resolution Square Wallpaper with Mild Blur in Parallel
# -----------------------------------------------------

echo ":: Generate reduced-resolution square wallpaper with mild blur..."
magick convert "$wallpaper" -resize "$resize_percentage" -blur "$square_blur" -gravity Center -extent 1:1 "$squarewallpaper" &
square_pid=$!
echo ":: Generating square wallpaper in the background..."

# ----------------------------------------------------- 
# Wait for Both Processes to Finish
# -----------------------------------------------------

wait $blurred_pid $square_pid
echo ":: Blurred and square wallpapers have been generated."

# ----------------------------------------------------- 
# Generate Default Wallpaper
# -----------------------------------------------------

# Convert the provided wallpaper to PNG format for the default wallpaper
echo ":: Generating new cached default wallpaper..."
magick convert "$wallpaper" "$default_wallpaper"
echo ":: Default wallpaper generated at $default_wallpaper"

