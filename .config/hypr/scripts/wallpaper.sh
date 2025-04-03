#!/bin/bash
#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# ----------------------------------------------------- 
# Optimized wallpaper processing script
# ----------------------------------------------------- 
# Variables
output_dir="$HOME/.cache/wallpaper"
default_wallpaper="$output_dir/default_wallpaper.png"
squarewallpaper="$output_dir/square_wallpaper.png"
blurred_wallpaper="$output_dir/blurred_wallpaper.png"
blur="50x30"
resize_percentage="70%"
square_blur="5x3"

# ----------------------------------------------------- 
# Checking Arguments
# ----------------------------------------------------- 
if [ -z "$1" ]; then
  echo "Error: No wallpaper path provided."
  echo "Usage: $0 <path_to_wallpaper>"
  exit 1
fi

wallpaper="$1"

if [ ! -f "$wallpaper" ]; then
    echo "Error: File does not exist: $wallpaper"
    exit 1
fi

# ----------------------------------------------------- 
# Check for file modification - skip processing if unchanged
# ----------------------------------------------------- 
mkdir -p "$output_dir"

# Create/check modification timestamp file
timestamp_file="$output_dir/last_wallpaper_info"
current_wallpaper_info="$wallpaper:$(stat -c %Y "$wallpaper")"

# Skip processing if the wallpaper hasn't changed
if [ -f "$timestamp_file" ] && [ "$(cat "$timestamp_file")" = "$current_wallpaper_info" ] && 
   [ -f "$default_wallpaper" ] && [ -f "$blurred_wallpaper" ] && [ -f "$squarewallpaper" ]; then
    echo ":: Wallpaper unchanged, using cached versions."
    
    # Still update color schemes
    wal -q -i "$wallpaper" --backend haishoku
    
    # Update pywalfox if installed
    if type pywalfox > /dev/null 2>&1; then
        pywalfox update
    fi
    
    exit 0
fi

# Kill waypaper if running
pkill -x "waypaper" 2>/dev/null

# ----------------------------------------------------- 
# Pywal
# -----------------------------------------------------
echo ":: Execute pywal with $wallpaper"
wal -q -i "$wallpaper" --backend haishoku

# ----------------------------------------------------- 
# Pywalfox
# -----------------------------------------------------
if type pywalfox > /dev/null 2>&1; then
    pywalfox update
fi

# ----------------------------------------------------- 
# Optimize image processing with a single ImageMagick call
# -----------------------------------------------------
echo ":: Generating all wallpaper versions..."

# Create a temporary script for processing to run in background
temp_script=$(mktemp)
cat > "$temp_script" << EOF
#!/bin/bash
# Process default wallpaper (just convert format)
magick convert "$wallpaper" "$default_wallpaper"

# Process blurred wallpaper
magick convert "$wallpaper" -resize "$resize_percentage" -blur "$blur" "$blurred_wallpaper"

# Process square wallpaper
magick convert "$wallpaper" -resize "$resize_percentage" -blur "$square_blur" -gravity Center -extent 1:1 "$squarewallpaper"

# Save wallpaper info for future cache checks
echo "$current_wallpaper_info" > "$timestamp_file"

echo ":: All wallpapers generated successfully."
EOF

chmod +x "$temp_script"

# Run the processing with reduced priority to minimize impact on system
nice -n 10 "$temp_script" &

echo ":: Wallpaper processing started in background with reduced priority."
