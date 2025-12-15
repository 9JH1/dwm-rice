#!/bin/bash 
# Show volume 
# 
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

echo "%{F$1 T1}V%{F- T-} $vol"
