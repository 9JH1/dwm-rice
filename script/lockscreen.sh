#!/bin/bash
# Locks the screen.
#

# Get theme color
source "$HOME/.cache/wal/colors.sh"
hex="${color3:1}10"

if [ "$1" = "--image" ];then
	# Take a screenshot
	maim -u  /tmp/screenlock.png 
	
	# Use it for lockscreen
	i3lock -i /tmp/screenlock.png 
	rm /tmp/screen.png
else 
	# Basic lockscreen using color
	i3lock -c "$hex" && systemctl suspend 
fi

