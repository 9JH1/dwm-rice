#!/bin/bash 
source "$HOME/.cache/wal/colors.sh"
read -r -d '' DUNSTRC << EOM
[global]
font = Mononoki Nerd Font Bold 16
markup = full
format = "<b>%s</b>\n<b>%b</b>"
icon_position = left
icon_path = /usr/share/icons/
max_icon_size = 32
show_indicators = false
separator_height = 2
padding = 2
frame_width = 3
separator_color = frame
shrink = yes
mouse_left_click = do_action
mouse_middle_click = close_current
mouse_right_click = close_current
width = (100,400)
progress_bar = false
progress_bar_min_width = (100,400)

[urgency_low]
foreground = "${color3:-#ffffff}"
background = "${color0:-#000000}"
frame_color = "${color1:-#888888}"

[urgency_normal]
foreground = "${color3:-#ffffff}"
background = "${color0:-#000000}"
frame_color = "${color1:-#888888}"

[urgency_critical]
foreground = "#ffffff"
background = "#ff5050"
frame_color = "#ff0000"
EOM
killall dunst
dunst -config <(echo "$DUNSTRC")
