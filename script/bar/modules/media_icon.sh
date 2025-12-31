#!/usr/local/bin/bash 
# Uses playerctl to display playing status
#

# Get status icon
icon=""
[ "$(playerctl status)" = "Playing" ] && {
	icon="||" # Playing
} || icon="|>" # Paused

# Get rating
rating=""

# Stars will be a float value between 0 and 1 its our job 
# to format it into a bar of five characters.
stars=$(playerctl metadata | grep userRating | tr ' ' '\n' | tail -n 1)
stars=$(echo "$stars*5" | bc);
stars=$(printf "%.0f" $stars)

for i in {1..5}; do
	[[ $i -lt $stars+1 ]] && {
		rating+="*"
	} || rating+=" "
done

echo "%{F$1}$icon [$rating]%{F-}"
