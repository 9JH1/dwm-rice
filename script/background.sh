#!/bin/bash
# USAGE:
# background.sh [OPTION] <path_to_img>
# OPTIONS:
# --use-last  | uses last set wallpaper
# --select    | opens ranger file selection menu


wallpaper="$1"
xwallpaper --zoom "$wallpaper"
