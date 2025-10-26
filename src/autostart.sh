killall nm-applet &
killall blueman-applet &
killall unclutter & 
killall lxqt-policykit-agent &
killall protonvpn-app &
wait 

xset r rate 150 50 &
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted &
$SCRIPT_DIR/wal.sh  && notify-send "Reloading autostart"
nm-applet &>/dev/null &
blueman-applet &>/dev/null &
protonvpn-app &>/dev/null &
unclutter --timeout 0.1 &>/dev/null &
lxqt-policykit-agent &>/dev/null &
#$HOME/Pictures/Wallpapers/.walltaker/walltaker.sh --id "53412" &


#reset downloads 
new_date="$(date | tr ' ' '_')"

mkdir "/drive/.downloads" &>/dev/null
rm ~/Downloads &>/dev/null

# remove empty download folders
find /drive/.downloads/ -depth -mindepth 1 -type d -empty -exec rmdir {} \;

mkdir "/drive/.downloads/Downloads_$new_date"
ln -s "/drive/.downloads/Downloads_$new_date" ~/Downloads
