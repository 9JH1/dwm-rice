#!/usr/local/bin/bash 
# Show volume 
# 
packet=$(pactl get-sink-volume @DEFAULT_SINK@) &>/dev/null
ret=$?
vol="!"

[ $ret -eq 0 ] && vol=$(echo "$packet" | tr '/' '\n' | head -n 2 | tail -n 1 | tr -d '%' | tr -d ' ')

echo "%{F$1}V%{F-} $vol%%"
