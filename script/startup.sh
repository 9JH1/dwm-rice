#!/bin/bash
# Ran on startup
SCRIPT_PATH="$HOME/.dwm/script"

#"$SCRIPT_PATH/background.sh" "~/Pictures/bg.png"

xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted
xsetroot -name "fsignal:1"
