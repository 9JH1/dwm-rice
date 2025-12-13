#!/bin/bash
# Takes a selction screenshot and also saves
# a fullscreen screenshot to ~/Pictures/screenshots

# Very Lazy init
mkdir ~/Pictures &>/dev/null
mkdir ~/Pictures/screenshots/ &>/dev/null

file_path=~/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png
tmp_file=$(mktemp --suffix=".png")

maim -s -u "$tmp_file" 
if [ $? -eq 0 ]; then 
	cat "$tmp_file" | xclip -selection clipboard -t image/png
	maim "$file_path"
	notify-send -i "$tmp_path" "Screenshot copied to clipboard"
fi
