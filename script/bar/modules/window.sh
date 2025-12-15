#!/bin/bash 
# prints the current selected window
#

wid=$(xdotool getactivewindow | head -n 1)
title=$(xprop -id $wid WM_NAME | tr '"' '\n' | head -n 2 | tail -n 1)

echo "%{F$1 T1}W%{T- F-} $title"
