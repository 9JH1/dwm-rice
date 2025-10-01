killall nm-applet &
killall blueman-applet &
killall unclutter & 
killall lxqt-policykit-agent &
wait 

xset r rate 150 50 &
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted &
$SCRIPT_DIR/wal.sh  && notify-send "Reloading autostart"
nm-applet & 
blueman-applet & 
unclutter --timeout 0.1 & 
lxqt-policykit-agent & 
plank &
$HOME/Pictures/Wallpapers/.walltaker/walltaker.sh --id "53412" &
