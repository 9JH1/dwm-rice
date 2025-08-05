#!/bin/bash

CONFIG="$HOME/.dwm/conf/kitty-extra.conf"

# Read current values
padding_set=false
opacity="1"

if grep -q "window_padding_width 40" "$CONFIG"; then
    padding_set=true
fi
if grep -q "background_opacity 0.5" "$CONFIG"; then
    opacity="0.5"
fi


rm -f $CONFIG
if [[ $1 == "-padding" ]]; then
    echo "background_opacity $opacity" >> "$CONFIG"

    if $padding_set; then
			echo "window_padding_width 0" >> "$CONFIG"
    else
      echo "window_padding_width 40" >> "$CONFIG"
    fi
else
    if $padding_set; then
        echo "window_padding_width 40" >> "$CONFIG"
    else
        echo "window_padding_width 0" >> "$CONFIG"
    fi

    if [[ $opacity == "0.5" ]]; then
        echo "background_opacity 1" >> "$CONFIG"
    else
        echo "background_opacity 0.5" >> "$CONFIG"
    fi
fi

cat "$CONFIG"
killall -SIGUSR1 kitty
