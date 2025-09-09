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

    # Extract states with defaults to 0 (handles null)
    old_urgent=$(echo "$event" | jq -r '.old_state.urgent // 0' 2>/dev/null)
    old_selected=$(echo "$event" | jq -r '.old_state.selected // 0' 2>/dev/null)
    old_occupied=$(echo "$event" | jq -r '.old_state.occupied // 0' 2>/dev/null)
    monitor=$(echo "$event" | jq -r '.monitor_number' 2>/dev/null)
    new_selected=$(echo "$event" | jq -r '.new_state.selected // 0' 2>/dev/null)
    new_occupied=$(echo "$event" | jq -r '.new_state.occupied // 0' 2>/dev/null)
    new_urgent=$(echo "$event" | jq -r '.new_state.urgent // 0' 2>/dev/null)

    if [[ -n "$monitor" && "$monitor" != "null" ]]; then
        out=""

        if (( new_selected == stack_tag )); then
            # Special case: Scratchpad selected, show only it (highlighted)
            out="%{-u}%{B$active_b}%{F$active_f}%{u$active_u}%{+u}$stack_title%{-u}%{B-}%{F-}"
        else
            # Normal tags: Loop 1-9, add only if occupied, highlight if selected
            for (( i=1; i<=9; i++ )); do
                bitwise=$((1 << (i-1)))
                if (( new_occupied & bitwise )); then
                    if (( new_selected & bitwise )); then
                        # Active/selected occupied tag
                        out+="%{-u}%{B$active_b}%{F$active_f}%{u$active_u}%{+u}${tag_titles[$((i-1))]}%{-u}%{B-}%{F-}"
                    else
                        # Inactive occupied tag
                        out+="%{-u}%{B$inactive_b}%{F$inactive_f}${tag_titles[$((i-1))]}%{-u}%{B-}%{F-}"
                    fi
                fi
            done
        fi

        # If no output (e.g., no occupied tags and not scratchpad), echo empty or default
        [[ -z "$out" ]] && out=" "
        echo "$out"
    fi
done
