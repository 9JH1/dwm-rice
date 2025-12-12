#!/bin/bash
mkdir ~/Pictures/screenshots/
file_path=~/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png
maim "$file_path" &	
maim -s -u | xclip -selection clipboard -t image/png
