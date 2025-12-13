#!/bin/bash
# Displays playing media.
#

len=60

if [[ "$(playerctl metadata --format '-' 2>/dev/null)" == *-* ]]; then
	raw_artist=$(playerctl -a metadata --format '{{ artist }}')
	raw_title=$(playerctl -a metadata --format '{{ title }}')

	# Shorten to len chars max with ...
	artist=$(echo "$raw_artist" | awk "{if(length > $len) printf \"%.$len's'...\n\", \$0; else print}")
	title=$(echo "$raw_title" | awk "{if(length > $len) printf \"%.$len's'...\n\", \$0; else print}")

	echo "%{T2}$artist - $title%{T-}"

else 
	echo "Nothing Playing"
fi
