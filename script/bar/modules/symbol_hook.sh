#!/bin/bash 
# Get the current layout mode symbol 
# using dwm-msg and write it to a cache 
# file for symbol.sh to display
#

continue_f="$1"
cache_f="$HOME/.cache/dwm_symbol_hook.txt"

dwm-msg get_layouts | grep "symbol" | head -n 1 | awk '{print $2}' | tr -d '",' | tee "$cache_f"

dwm-msg subscribe layout_change_event \
  | jq -r '.layout_change_event.new_symbol' --unbuffered \
  | while read -r sym; do
		[ ! -e "$continue_f" ] && exit 
        echo "$sym" | tee "$cache_f"
    done

