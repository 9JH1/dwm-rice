#!/bin/bash 
# Uses playerctl to display playing status
#

stat=$(playerctl status)
icon=""

[ ! "$stat" = "Paused" ] && {
	icon="||"
} || {
	icon="|>"
}

echo "%{F$1 T1}$icon%{F- T-}"
