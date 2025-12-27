#!/usr/local/bin/bash
# Takes a selction screenshot and also saves
# a fullscreen screenshot to ~/Pictures/screenshots

# Very Lazy init
mkdir ~/Pictures &>/dev/null
mkdir ~/Pictures/screenshots/ &>/dev/null

prefix=~/Pictures/screenshots/
file="$(date +'%Y-%m-%d_%H-%M-%S').png"
tmp="tmp_$file"

maim -s -u "$prefix$tmp" 
if [ $? -eq 0 ]; then 
	cat "$prefix$tmp" | xclip -selection clipboard -t image/png
	maim "$prefix$file"
	notify-send -i "$prefix$tmp" "Screenshot copied to clipboard"
fi
