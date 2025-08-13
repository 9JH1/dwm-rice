#!/bin/bash
source ~/.cache/wal/colors.sh
if [[ "$(playerctl metadata --format '-' 2>/dev/null)" == *-* ]]; then
	raw_artist=$(playerctl -a metadata --format '{{ artist }}')
	raw_title=$(playerctl -a metadata --format '{{ title }}')

	# Shorten to 10 chars max with ...
	artist=$(echo "$raw_artist" | awk '{if(length > 20) printf "%.20s...\n", $0; else print}')
	title=$(echo "$raw_title" | awk '{if(length > 20) printf "%.20s...\n", $0; else print}')

	echo "$artist %{F$color0}-%{F$color7} %{T2}$title%{T-}"

else 
	echo ""
fi
