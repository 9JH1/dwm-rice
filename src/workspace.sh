#!/bin/bash

# Load pywal colors
source ~/.cache/wal/colors.sh

# Tag definitions
stack_tag=511
stack_title=" "
tag_titles=("1" "2" "3" "4" "5" "6" "7" "8" "9")
padding=5 # padding in px

# Function to draw workspaces for a given monitor
function draw_workspaces {
  local event=$1
  local monitor=$(echo "$event" | jq -r '.monitor_number // 0' 2>/dev/null)
  local new_selected=$(echo "$event" | jq -r '.new_state.selected // 0' 2>/dev/null)
  local new_occupied=$(echo "$event" | jq -r '.new_state.occupied // 0' 2>/dev/null)
  local new_urgent=$(echo "$event" | jq -r '.new_state.urgent // 0' 2>/dev/null)

  # Only process if monitor is valid
  if [[ -n "$monitor" && "$monitor" != "null" ]]; then
    local out=""
    if (( new_selected == stack_tag )); then
      # Special case: Scratchpad selected, show only it (highlighted)
      out="$stack_title"
    else
      # Normal tags: Loop 1-9, add only if occupied, highlight if selected
      for (( i=1; i<=9; i++ )); do
        local bitwise=$((1 << (i-1)))
        if (( new_occupied & bitwise | new_selected & bitwise )); then
          if (( new_selected & bitwise )); then
            # Active/selected occupied tag
            out+="%{B$color5}%{F$color0}%{O$padding}${tag_titles[$((i-1))]}%{O$padding}%{B- F-}"
          else
            # Inactive occupied tag
            out+="%{O$padding}${tag_titles[$((i-1))]}%{O$padding}"
          fi

        fi
      done
    fi
    # If no output (e.g., no occupied tags and not scratchpad), echo empty or default
    [[ -z "$out" ]] && out=" "
    echo "$out"
  fi
}

# Function to get current state for a monitor
function get_monitor_state {
  local monitor=$1
  # Query dwm for the current state of the specified monitor
  local state=$(dwm-msg get_monitors | jq -r ".[] | select(.num == $monitor) | .tag_state")
  if [[ -n "$state" && "$state" != "null" ]]; then
    echo "$state"
  else
    echo "{}"
  fi
}

# Main event loop
dwm-msg subscribe tag_change_event monitor_added_event monitor_removed_event | jq -c --unbuffered \
  'select(.tag_change_event or .monitor_added_event or .monitor_removed_event) | 
   if .tag_change_event then {type: "tag_change", data: .tag_change_event}
   elif .monitor_added_event then {type: "monitor_added", data: .monitor_added_event}
   else {type: "monitor_removed", data: .monitor_removed_event} end' | \
while IFS= read -r event; do
  event_type=$(echo "$event" | jq -r '.type')
  case "$event_type" in
    "tag_change")
      # Handle tag change event
      draw_workspaces "$(echo "$event" | jq -r '.data')"
      ;;
    "monitor_added" | "monitor_removed")
      # Handle monitor change: Get current state for each connected monitor
      monitors=$(dwm-msg get_monitors | jq -r '.[].num')
      for monitor in $monitors; do
        state=$(get_monitor_state "$monitor")
        if [[ -n "$state" ]]; then
          draw_workspaces "$state"
        fi
      done
      ;;
  esac
done
