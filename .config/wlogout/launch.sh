#!/bin/bash

# Check if waypaper is running
if ! pgrep -x "wlogout" > /dev/null; then
    echo "Wlogout is not running. Starting wlogout..."
    wlogout -b 4 --buttons-per-row 2 --margin-left 500 --margin-right 500 &
else
    echo "Wlogout is already running."
fi
