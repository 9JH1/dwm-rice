#!/bin/bash
notify-send "Reloading Autostart"

killall unclutter & 
killall lxqt-policykit-agent &
killall nemo-desktop
killall unclutter
killall nm-applet
wait 

xset r rate 150 50 &
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted &
$SCRIPT_DIR/wal.sh
unclutter --timeout 0.1 &>/dev/null &
lxqt-policykit-agent &>/dev/null &
nm-applet &
setxkbmap -layout "us,us" -variant ",dvorak" -option "" -option "grp:alt_shift_toggle"

#(
#	while [[ "$(ps aux | grep "dwm$" | wc -l)" -eq 1 ]];do 
#		sleep 1;
		nemo-desktop &
#	done
#) & 



#$HOME/Pictures/Wallpapers/.walltaker/walltaker.sh --id "53412" &

new_time=$(date | tr ' ' '_')
base_dl_dir="/drive/.downloads/"
main_dl_dir="/drive/.downloads/Downloads/"

new_dl_dir="$base_dl_dir$new_time"_DOWNLOADS

# Move and remove old downloads
mv ~/Downloads/* "$main_dl_dir"
rm ~/Downloads
find "$base_dl_dir" -depth -type d -exec rmdir {} \; 

# Create new downloads folder 
mkdir "$new_dl_dir"
ln -s "$new_dl_dir" ~/Downloads
