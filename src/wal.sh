#!/bin/bash
is_video() {
	local file="$1"
	ext="|gif|mp4|mkv|avi|mov|wmv|flv|webm|mpeg|mpg|m4v|3gp"
	if echo "$file" | grep -i -E "\.($ext)$"; then return 0; fi
	return 1;
}

is_image() {
	local file="$1"
	ext="|jpg|png|webp|jpeg|bmp|" 
	if echo "$file" | grep -i -E "\.($ext)$"; then return 0; fi 
	return 1;
}

killall motionlayer &>/dev/null
first_wall=""
if [[ "$1" = "--custom" ]];then
	if is_video "$2";then
		echo "detected video"
		# VIDEO WALLPAPER SECION (https://github.com/9jh1/C -> projects/motionlayer/src)

		motionlayer --path "$2" --frame-out "$HOME/.frame.jpg" & 
		sleep 1
		first_wall="$HOME/.frame.jpg"
		echo "$first_wall" > $HOME/.wallpaper
	elif is_image "$2"; then
		echo "detected image"
		first_wall="$2";
	else 
		echo "Couldent load file" "$2"
		exit
	fi
	echo "Loading file" "$2"
else 
	WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
	if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist"
    exit 1
	fi
	if [[ -n "$1" ]]; then
  	if [[ "$1" = "--exclude-hidden" ]]; then
  		wallpaper=$(find -L "$WALLPAPER_DIR" -type f -not -path "*/.*/**" | grep -v ".git" | shuf -n 1)
			$HOME/.dwm/src/wal.sh --custom "$wallpaper";
			exit 
  	else
			wallpaper=$(find -L "$WALLPAPER_DIR" -type f -path "*/.*/**" | grep -v ".git" | shuf -n 1)
			$HOME/.dwm/src/wal.sh --custom "$wallpaper"
			exit
		fi
	else 
		first_wall=$(cat ~/.wallpaper)
	fi 
fi

export XDG_CACHE_HOME="$HOME/.cache" &> /dev/null &
touch $HOME/.wallpaper

# run wal 
echo "$first_wall" > $HOME/.wallpaper
log_file=$(mktemp --suffix=.txt)
wal -i "$first_wall" -e -t -n -a 92 > $log_file   
if [ "$?" -ne "0" ];then
	cat $log_file
	notify-send "Wal Error Occured"
	killall motionlayer
	exit
fi 


# set color
source ~/.cache/wal/colors.sh
hex="$color5"
solid_color_ppm=$(mktemp --suffix=.ppm)
printf "P6\n1 1\n255\n\\x${hex:1:2}\\x${hex:3:2}\\x${hex:5:2}" > "$solid_color_ppm"
(feh --bg-scale "$solid_color_ppm" && rm -f "$solid_color_ppm" &)

if ! is_video "$2"; then 
	pkill -f xwallpaper

	# set wallpaper on primary monitor
	output=$(xrandr | grep "primary" | awk '{print $1}')
	if [ ! -v $output ];then 
		xwallpaper --output  $output --zoom "$first_wall"
	else 
		xwallpaper --zoom "$first_wall"
	fi

	if [ "$?" != "0" ];then
		echo "XWallpaper error"
	fi
fi


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# echo fix picom
if [[ $(pgrep "picom") = "" ]];then 
	echo "Picom exited for some reason"
	echo "Starting Picom"
	picom --config "$SCRIPT_DIR/../conf/picom.conf" &
fi 

# start deps 
$SCRIPT_DIR/wal_deps.sh &>/dev/null
