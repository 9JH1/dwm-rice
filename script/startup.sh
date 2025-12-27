#!/bin/bash
# Startup script (run on launch) 
# 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Quit old programs
killall unclutter lxqt-policykit-agent nemo-desktop unclutter nm-applet snixembed


# Setup, this isent really required but because of the autostart keybind $mod+r 
# its nice to be able to easily re-run programs very easily as sometimes they can 
# just stop.
xset r rate 150 50 &
setxkbmap -layout "us,us" -variant ",dvorak" -option "" -option "grp:alt_shift_toggle"
unclutter --timeout 0.1 &>/dev/null &

# Change screen (for my layout specifically, remove if your screens layout weird (inverted and below second mon)
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted &

# Actual applications / services
lxqt-policykit-agent &>/dev/null &
nm-applet &
nemo-desktop & 
snixembed &


# Scripts (this must go last)
$SCRIPT_DIR/background.sh &>/dev/null & 
$SCRIPT_DIR/compositor.sh --restart &
