#!/bin/bash


(xrdb -merge -quiet "$HOME/.cache/wal/colors.Xresources" && dwm-msg run_command xrdb) &

SCRIPT_DIR="$HOME/.dwm/src"
$SCRIPT_DIR/dunst.sh &>/dev/null &
$SCRIPT_DIR/polybar.sh &>/dev/null &
$SCRIPT_DIR/alacritty.sh no-run &>/dev/null & 
$SCRIPT_DIR/reloadwalgtk.sh &>/dev/null &
$SCRIPT_DIR/conky.sh &>/dev/null &

sh "$HOME/.cache/wal/colors-tty.sh" &

walcord &>/dev/null &

if [[ ! "$(pgrep 'qutebrowser')" = "" ]]; then
	qutebrowser :config-source &
fi
