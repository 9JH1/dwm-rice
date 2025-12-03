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

first_wall=""
log_file=$(mktemp --suffix=.txt)
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
cache_file="/home/$USER/.cache/wal_background"
cache_frame="/home/$USER/.cache/wal_video_frame.jpg"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist"
	notify-send "Wal Script Error" "$WALLPAPER_DIR does not exist, Creating it now but you must add files to this dir to use as wallpapers"
	mkdir "$WALLPAPER_DIR"
  exit 1
fi

# init the cache file 
if [[ ! -e "$cache_file" ]];then 
	touch "$cache_file"
fi

# init the cache frame (used in video wallpapers)
if [[ ! -e "$cache_frame" ]]; then 
	touch "$cache_frame"
fi

# kill video wallpapers
killall motionlayer &>/dev/null


# redirect or get wallpaper
if [[ "$1" = "--custom" ]];then

	# set video wallpaper 
	if is_video "$2";then
		echo "detected video"
		motionlayer --path "$2" --frame-out "$cache_frame" & 
		first_wall="$cache_frame"
		sleep 0.5
	
	# set image wallpaper 
	elif is_image "$2"; then
		echo "detected image"
		first_wall="$2";

	# error occured
	else 
		echo "Couldent load file: $2"
		notify-send "Wal Script Error:" "Couldent Load File: $2, check wal.sh is_image and is_video functions to see if the file ext is supported"
		exit
	fi

# no arguments where run with wal script
else 
	if [[ -n "$1" ]]; then
		num_wallpapers=$(ls -l "$WALLPAPER_DIR" | wc -l)

		if [ $num_wallpapers -lt 1 ];then 
			echo "No wallpapers in $WALLPAPER_DIR"
			notify-send "Wal Script Error" "No wallpapers in $WALLPAPER_DIR"
		fi

		# redirect with a random wallpaper
  	if [[ "$1" = "--exclude-hidden" ]]; then
  		wallpaper=$(find -L "$WALLPAPER_DIR" -type f -not -path "*/.*/**" | grep -v ".git" | shuf -n 1)
			"$SCRIPT_DIR/wal.sh" --custom "$wallpaper";
			exit 
  	else
			wallpaper=$(find -L "$WALLPAPER_DIR" -type f -path "*/.*/**" | grep -v ".git" | shuf -n 1)
			"$SCRIPT_DIR/wal.sh" --custom "$wallpaper"
			exit
		fi
	
	# use the last set wallpaper
	else 
		first_wall=$(cat ~/.wallpaper)
	fi 
fi


# run wal  
echo "$first_wall" > $HOME/.wallpaper

export XDG_CACHE_HOME="$HOME/.cache" &> /dev/null &
wal -i "$first_wall" -e -t -n -a 92 > $log_file   

# check wal code
if [ "$?" -ne "0" ];then
	echo "Wal error occured"
	notify-send "Wal Script Error" "Wal error occured. Opening log.."
	xdg-open "$log_file"
	exit
fi 


# set secondary monitor(s) background color 
source ~/.cache/wal/colors.sh
hex="$color5"
solid_color_ppm=$(mktemp --suffix=.ppm)
printf "P6\n1 1\n255\n\\x${hex:1:2}\\x${hex:3:2}\\x${hex:5:2}" > "$solid_color_ppm"
(feh --bg-scale "$solid_color_ppm" && rm -f "$solid_color_ppm" &)

# set primary monitor wallpaper
if ! is_video "$2"; then 
	pkill -f xwallpaper

	output=$(xrandr | grep "primary" | awk '{print $1}')
	if [ ! -v $output ];then 
		xwallpaper --output  $output --zoom "$first_wall"
	else 
		xwallpaper --zoom "$first_wall"
	fi

	if [ "$?" != "0" ];then
		echo "XWallpaper error"
		notify-send "Wal Script Error" "XWallpaper Error"
		exit
	fi
fi


# run dependancies

# start dunst 
$SCRIPT_DIR/dunst.sh &>/dev/null &

# start polybar 
$SCRIPT_DIR/polybar.sh &>/dev/null &

# reload alacritty 
$SCRIPT_DIR/alacritty.sh no-run &>/dev/null & 


# use walcord to set discord colors 
walcord &>/dev/null &

# reload qutebrowser colors
if [[ ! "$(pgrep 'qutebrowser')" = "" ]]; then
	qutebrowser :config-source &>/dev/null &
fi

# reload xrdb colors
xrdb -merge -quiet "$HOME/.cache/wal/colors.Xresources" && dwm-msg run_command xrdb

# reload gtk colors 
if [[ -e "/home/$USER/.themes/oomox-gtk-theme/change_color.sh" ]]; then 
	~/.themes/oomox-gtk-theme/change_color.sh ~/.cache/wal/colors-oomox &>/dev/null
	tmp=$(mktemp)
	echo 'Net/ThemeName "oomox-colors-oomox"' > "$tmp"
	timeout 0.2s xsettingsd -c "$tmp" &>/dev/null
	rm -f $tmp
else 
	echo "oomox not installed correctly.."
	notify-send "Wal Error" "oomox not installed correctly.."
	exit 
fi

#notify-send "Wal Info" "Wal script has completed"
