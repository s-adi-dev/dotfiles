#!/bin/bash
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#

# Get clipboard history using cliphist and show it in rofi with an extra option to clear the clipboard
selected=$( (echo "Clear Clipboard"; cliphist list | cut -f2-) | rofi -dmenu -p " " )

# Check user selection
if [[ "$selected" == "Clear Clipboard" ]]; then
    cliphist wipe
elif [[ -n "$selected" ]]; then
    echo -n "$selected" | wl-copy
fi
