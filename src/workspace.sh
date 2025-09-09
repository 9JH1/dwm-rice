#!/bin/bash

source ~/.cache/wal/colors.sh

active_b="$color3"
active_f="$background"
active_u="$color7"
inactive_b="$color2"
inactive_f="$background"

stack_tag=511
stack_title="Scratchpad"
tag_titles=("1" "2" "3" "4" "5" "6" "7" "8" "9")

echo "Workspaces" 
dwm-msg subscribe tag_change_event | jq -c --unbuffered 'select(.tag_change_event) | .tag_change_event' | while IFS= read -r event; do
    [[ -z "$event" ]] && continue

    old_urgent=$(echo "$event" | jq -r '.old_state.urgent' 2>/dev/null)
    old_selected=$(echo "$event" | jq -r '.old_state.selected' 2>/dev/null)
    old_occupied=$(echo "$event" | jq -r '.old_state.occupied' 2>/dev/null)
    monitor=$(echo "$event" | jq -r '.monitor_number' 2>/dev/null)
    new_selected=$(echo "$event" | jq -r '.new_state.selected' 2>/dev/null)
    new_occupied=$(echo "$event" | jq -r '.new_state.occupied' 2>/dev/null)
    new_urgent=$(echo "$event" | jq -r '.new_state.urgent' 2>/dev/null)

  if [[ -n "$monitor" && "$monitor" != "null" ]]; then
		out="";
		final="";

		# 9 being the amount of tags
		for(( i=1; i<=9; i++ ));do 
		bitwise=$((2**(i-1)))
			if [[ "$new_selected" == "$bitwise" ]];then
				out="%{-u}%{B$inactive_b}%{F$inactive_f}$out%{B$active_b}%{F$active_f}%{u$active_u}%{+u}${tag_titles[$((i-1))]}%{-u B$inactive_b F$inactive_f}";
				final=$bitwise;
			elif [[ "$new_selected" == "$stack_tag" ]];then 
				out="$stack_title";
				final="$stack_tag"
			else out="$out${tag_titles[$((i-1))]}"; fi
		done
		echo "$out"
  fi
done
