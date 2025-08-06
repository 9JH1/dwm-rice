SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x1080 --rotate inverted &
$SCRIPT_DIR/src/wal.sh  &
$HOME/Pictures/Wallpapers/.walltaker/walltaker.sh --id "46554" &
nm-applet & 
blueman-applet & 
unclutter --timeout 0.1 & 
lxqt-policykit-agent & 
xset r rate 200 35 &
