#!/bin/bash 
source ~/.cache/wal/colors.sh

out=""
if [ $(playerctl status) == "Playing" ]; then
	out+=" "
else 
	out+=" "
fi

#exclude icon
out=""
if [[ "$(playerctl metadata --format '-' 2>/dev/null)" == *-* ]]; then
	raw_artist=$(playerctl -a metadata --format '{{ artist }}')
	raw_title=$(playerctl -a metadata --format '{{ title }}')

	# Shorten to 10 chars max with ...
	artist=$(echo "$raw_artist" | awk '{if(length > 100) printf "%.100s...\n", $0; else print}')
	title=$(echo "$raw_title" | awk '{if(length > 100) printf "%.100s...\n", $0; else print}')

	# out+="$artist - %{T2}$title%{T-}"
	
	# exclude formating.
	out+="%{T2}$artist - $title%{T-}"
	
	echo "$out"
else 
	echo ""
fi
