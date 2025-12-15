#!/bin/bash
# gets the mouse location and figures out what monitor 
# would be in that position.
#

eval "$(xdotool getmouselocation --shell)"

# Find monitor with matching geometry
monitor=$(xrandr --query | awk -v X="$X" -v Y="$Y" '
  /^[^ ]+ connected/ { name=$1 }
  /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/ {
    match($0, /([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)/, m)
    if (m[1] != "" && m[2] != "" && m[3] != "" && m[4] != "") {
      w = m[1]; h = m[2]; ox = m[3]; oy = m[4]
      if (X >= ox && X < ox + w && Y >= oy && Y < oy + h) {
        print name
        exit
      }
    }
  }
')

echo "$monitor"
