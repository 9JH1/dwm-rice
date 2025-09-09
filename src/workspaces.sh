#!/bin/bash

tag_count=10 
stack_tag=511

dwm-msg subscribe tag_change_event | jq -c --unbuffered 'select(.tag_change_event) | .tag_change_event' | while IFS= read -r event; do
    [[ -z "$event" ]] && continue

    # Extract fields from the JSON object using jq
    old_urgent=$(echo "$event" | jq -r '.old_state.urgent' 2>/dev/null)
    old_selected=$(echo "$event" | jq -r '.old_state.selected' 2>/dev/null)
    old_occupied=$(echo "$event" | jq -r '.old_state.occupied' 2>/dev/null)
    monitor=$(echo "$event" | jq -r '.monitor_number' 2>/dev/null)
    new_selected=$(echo "$event" | jq -r '.new_state.selected' 2>/dev/null)
    new_occupied=$(echo "$event" | jq -r '.new_state.occupied' 2>/dev/null)

    new_urgent=$(echo "$event" | jq -r '.new_state.urgent' 2>/dev/null)

    # Check if jq parsed the fields successfully
  if [[ -n "$monitor" && "$monitor" != "null" ]]; then
		out="";
		final="";
		for(( i=1; i<=tag_count; i++ ));do 
		bitwise=$((2**(i-1)))
			if [[ "$new_selected" == "$bitwise" ]];then
				out="$out[$i]";
				final=$bitwise;
			elif [[ "$new_selected" == "$stack_tag" ]];then 
				out="test";
				final="$stack_tag"
			else out="$out $i "; fi
		done
		echo "$out -> $final"
  fi
done
