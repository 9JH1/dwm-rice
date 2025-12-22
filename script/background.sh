#!/bin/bash
# Sets background using wal color generator 
# runs background.2 AFTER finish.
# 

# File type function 
ft() {
    [[ $(file --mime-type -b "$1") == video/* ]] && return 0;
    [[ $(file --mime-type -b "$1") == image/* ]] && return 1;
}

err(){
	echo "Error: $1."
	notify-send "Wal Script" "$1."
	exit 1
}

wallpaper=""
log_file=$(mktemp --suffix=.txt)
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"

# Check if wallpaper dir exist
[[ ! -d "$WALLPAPER_DIR" ]] && err "$WALLPAPER_DIR does not exist";

# Init the cache file 
cache_file="/home/$USER/.cache/wal_background"
[[ ! -e "$cache_file" ]] && touch "$cache_file"

# Init the cache frame (used in video wallpapers)
cache_frame="/home/$USER/.cache/wal_video_frame.jpg"
[[ ! -e "$cache_frame" ]] && touch "$cache_frame"

# Parse file
[[ "$1" = "--custom" ]] && {
	# Determine type of wallpaper 
	ft && { 
		# File is a video 
		motionlayer --path "$2" --frame-out "$cache_frame" & 
		wallpaper="$cache_frame"
		sleep 0.5

	} || {
		# File is an image
		wallpaper="$2"
	}
} || {
	# Prompt for new wallpaper
	[[ "$1" = "--select" ]] && {
		old_wall=$(cat $cache_file);
		old_sha=$(echo "$old_wall" | sha1sum);

		# Run ranger choosefile dialog
		st -c "iso_term" -e sh -c "ranger --choosefile \"$cache_file\" \"$WALLPAPER_DIR\" --cmd=\"sort random\""		

		# Exit if selected is same as old wallpaper
		[[ "$(cat "$cache_file" | sha1sum)" = "$old_sha" ]] && {
			err "Selected wallpaper is same as old wallpaper"
		}
	}
	
	# Use old wallpaper
	wallpaper=$(cat "$cache_file")
}

# kill prior video wallpaper
killall motionlayer &>/dev/null

# run wal  
wal -i "$wallpaper" -e -t -n -a 92 --saturate 1  --contrast 20 

# check wal code
if [ "$?" -ne "0" ];then
	err "Wal failed"
	exit
fi 

# set secondary monitor(s) background color 
source ~/.cache/wal/colors.sh
solid_color_ppm=$(mktemp --suffix=.ppm)

hex="$background"
printf "P6\n1 1\n255\n\\x${hex:1:2}\\x${hex:3:2}\\x${hex:5:2}" > "$solid_color_ppm"
(feh --bg-scale "$solid_color_ppm" && rm -f "$solid_color_ppm" &)

# Set primary monitor wallpaper
if ! ft "$wallpaper"; then 
	pkill -f xwallpaper

	output=$(xrandr | grep "primary" | awk '{print $1}')
	xwallpaper --output  $output --zoom "$wallpaper"

	[[ "$?" != "0" ]] && err "XWallpaper failed"
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
$SCRIPT_DIR/background.2
