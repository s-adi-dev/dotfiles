#!/bin/bash
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#

# Get clipboard history using cliphist and show it in rofi
selected=$(cliphist list | cut -f2- | rofi -dmenu -p " ")

# If a selection is made, copy it back to clipboard
if [[ -n "$selected" ]]; then
    echo -n "$selected" | wl-copy
fi
