#!/bin/bash

SCRIPT_DIR="$HOME/.dwm/src"

# important things first
echo "Reloading Dunst"
$SCRIPT_DIR/dunst.sh >/dev/null &
echo "Starting Polybar"
killall polybar 
$SCRIPT_DIR/polybar.sh &>/dev/null &

# reload I3 and everything else that we dident reload 
# because of the pywal -e flag this part is copyed from 
# the offical reload.py file on pywals github, its just 
# been translated into bash.
echo "Reloading TTY"
sh "$HOME/.cache/wal/colors-tty.sh"
echo "Reloading XRDB"
xrdb -merge -quiet "$HOME/.cache/wal/colors.Xresources"

# less important things 
echo "Reloading Kitty"
$SCRIPT_DIR/alacritty.sh no-run >/dev/null & 
echo "Reloading Walcord"
walcord &>/dev/null &
echo "Reloading Qutebrowser"
if [[ ! "$(pgrep 'qutebrowser')" = "" ]]; then
	qutebrowser :config-source &
fi
echo "Reloading GTK"
$SCRIPT_DIR/reloadwalgtk.sh >/dev/null &
echo "Done"
