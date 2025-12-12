#!/bin/bash
# sets primary monitor background image but also 
# sets all secondary and other monitors to a 
# solid color generated from the wal color 
# pallete
#
# These options are available
# --use-last  | uses last set wallpaper
# --select    | opens ranger file selection menu

vid_ext="|gif|mp4|mkv|avi|mov|wmv|flv|webm|mpeg|mpg|m4v|3gp"
img_ext="|jpg|png|webp|jpeg|bmp|"
cache_file="$HOME/.cache/dwm_wallpaper_cache"
cache_frame="$HOME/.cache/dwm_video_wallpaper_cache"
wallpaper_dir="$HOME/Pictures/Wallpapers/"
wallpaper="$1"

is_video() {
	local file="$1"
	if echo "$file" | grep -i -E "\.($vid_ext)$"; then return 0; fi
	return 1;
}

is_image() {
	local file="$1"
	if echo "$file" | grep -i -E "\.($img_ext)$"; then return 0; fi 
	return 1;
}

# Error check & correction
if [[ ! -d "$wallpaper_dir" ]]; then 
	echo "$wallpaper_dir invalid"
	exit 
fi

[[ ! -e "$cache_file" ]] && touch "$cache_file"
[[ ! -e "$cache_frame" ]] && touch "$cache_frame"

# Run modes
if [ "$1" = "--select" ];then 
	old_sum="$(cat $cache_file)"
	st -c "iso_term" -e sh -c "ranger --choosefile \"$cache_file\" \"$wallpaper_dir\" --cmd=\"sort random\""
	[[ "$(cat "$cache_file" | sha1sum)" = "$old_sum" ]] && exit 
fi

if [ "$1" = "--select" ] || [ "$1" = "--use-last" ];then 
	wallpaper="$(cat $cache_file)"
fi

# Determine type 
if is_video "$wallpaper"; then
	killall motionlayer &>/dev/null
	motionlayer --path "$1" --frame-out "$cache_frame" &
	wallpaper="$cache_frame"
	sleep 0.5;

elif ! is_image "$wallpaper"; then
	echo "Image is not supported"
	echo "Supported image extensions:"
	echo "$img_ext"
	echo "Supported video extensions:"
	echo "$vid_ext"
	exit 1
fi

# Generate pallete 
echo "$wallpaper" > $cache_file
wal -i "$wallpaper" -e -t -n -a 92 --saturate 1

# Set solid color wallpaper 
source ~/.cache/wal/colors.sh
hex="$color5"
solid_color_ppm=$(mktemp --suffix=.ppm)
printf "P6\n1 1\n255\n\\x${hex:1:2}\\x${hex:3:2}\\x${hex:5:2}" > "$solid_color_ppm"
cat $solid_color_ppm
(feh --bg-scale "$solid_color_ppm" && rm -f "$solid_color_ppm" &)

# Set image wallpaper 
if is_image "$wallpaper"; then 
	output=$(xrandr | grep "primary" | awk '{print $1}')
	
	if [ ! -v $output ];then 
		xwallpaper --output  $output --zoom "$wallpaper"
	else 
		xwallpaper --zoom "$wallpaper"
	fi
fi 

# ------------------------------------
# DEPENANCIES
# ------------------------------------

xrdb -merge -quiet "$HOME/.cache/wal/colors.Xresources"
#xsetroot -name "fsignal:1"


exit 0
