#!/bin/bash 
# Uses playerctl to display playing status
#

stat=$(playerctl status)
icon=""

[ "$stat" = "Playing" ] && {
	icon="||"
} || {
	icon="|>"
}

echo "%{F$1}< $icon >%{F-}"
