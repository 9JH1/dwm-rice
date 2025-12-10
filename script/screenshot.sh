#!/bin/bash
# Basic screenshot script

# Create dirs
mkdir ~/Pictures &>/dev/null
mkdir ~/Pictures/screenshots/ &>/dev/null

# Get paths
file_path=~/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S')
file_cut_path=$file_path"_tmp.png"
file_path=$file_path".png"

# Get selection
maim -s -u $file_cut_path && xclip -selection clipboard -t image/png -i $file_cut_path

# Get full size screenshot
maim "$file_path"	
