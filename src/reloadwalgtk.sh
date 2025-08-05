#!/bin/bash
~/.themes/oomox-gtk-theme/change_color.sh ~/.cache/wal/colors-oomox
tmp=$(mktemp)
echo $tmp
echo 'Net/ThemeName "oomox-colors-oomox"' > "$tmp"
cat $tmp
timeout 0.2s xsettingsd -c "$tmp"
rm -f $tmp
