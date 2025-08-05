#!/bin/bash

CONFIG="$HOME/.dwm/conf/alacritty-extra.toml"

# Read current values
padding_set=false
opacity="1"

if grep -q "y=40" "$CONFIG"; then
    padding_set=true
fi
if grep -q "opacity=0.5" "$CONFIG"; then
    opacity="0.5"
fi

if [[ $1 == "-padding" ]]; then
    echo "changing padding"
    # Write config with preserved opacity
    echo "[window]" > "$CONFIG"
    echo "opacity=$opacity" >> "$CONFIG"

    echo "[window.padding]" >> "$CONFIG"
    if $padding_set; then
        echo "y=0" >> "$CONFIG"
        echo "x=0" >> "$CONFIG"
    else
        echo "y=40" >> "$CONFIG"
        echo "x=40" >> "$CONFIG"
    fi
else
    echo "setting opacity"
    # Write config with preserved padding
    echo "[window.padding]" > "$CONFIG"
    if $padding_set; then
        echo "y=40" >> "$CONFIG"
        echo "x=40" >> "$CONFIG"
    else
        echo "y=0" >> "$CONFIG"
        echo "x=0" >> "$CONFIG"
    fi

    echo "[window]" >> "$CONFIG"
    if [[ $opacity == "0.5" ]]; then
        echo "opacity=1" >> "$CONFIG"
    else
        echo "opacity=0.5" >> "$CONFIG"
    fi
fi

cat "$CONFIG"

