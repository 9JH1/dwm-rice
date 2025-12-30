#!/usr/local/bin/bash 
# Uses playerctl to display playing status
#


icon=""

[ "$(playerctl status &>/dev/null)" = "Playing" ] && {
	icon="||"
} || {
	icon="|>"
}

echo "%{F$1}< $icon >%{F-}"
