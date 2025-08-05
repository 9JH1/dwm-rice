#!/bin/bash
isolate=0;
if [ ! -n "$1" ]; then 
	isolate=1;
	echo "isolate enabled"
fi

read -r -d '' KITTY_CONFIG << EOM
include ~/.dwm/conf/kitty-extra.conf
font_family Mononoki Nerd Font Bold
bold_font MonaspiceRN NFM Bold 
italic_font VictorMono NFM Bold Italic 
bold_italic_font VictorMono NFM Bold Italic
font_size 15
disable_ligatures never 

cursor_shape beam
cursor_shape_unfocused underline
cursor_trail 1
cursor_trail_decay 0.1 0.4
cursor_trail_start_threshold 2

scrollback_indicator_opacity 0.1
mouse_hide_wait 0.1

url_style curly
detect_urls yes
show_hyperlink_targets yes

confirm_os_window_close 0
initial_window_width  85c 
initial_window_height 23c 
remember_window_size no 
allow_remote_control yes
background_blur 0
EOM

KITTY_PATH=$(mktemp --suffix=".conf")
KITTY_COLORS=$(cat $HOME/.cache/wal/colors-kitty.conf | grep -v "background_opacity")
echo "$KITTY_CONFIG" > "$KITTY_PATH"
echo "$KITTY_COLORS" >> "$KITTY_PATH"

killall -SIGUSR1 kitty

if [ "$1" = "no-run" ]; then
	exit
fi 

if [ -n "$1" ]; then 

	kitty --config="$KITTY_PATH" --class="isolated_terminal" /bin/sh -c "export ZSH_ISOLATE=$isolate && export ZDOTDIR=$HOME/.dwm/conf/ && zsh"
else 
	kitty --config="$KITTY_PATH" /bin/sh -c "export ZDOTDIR=$HOME/.dwm/conf/ && export ZSH_ISOLATE=$isolate && zsh"
fi
