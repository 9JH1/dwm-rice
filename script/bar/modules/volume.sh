#!/usr/local/bin/bash 
# Show volume 
# 
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | tr ' ' '\n' | grep "%$" | head -n 1)

echo "%{F$1 T1}V%{F- T-} $vol"
