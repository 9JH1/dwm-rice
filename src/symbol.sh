#!/bin/bash 
dwm-msg get_layouts | grep "symbol" | head -n 1 | awk '{print $2}' | tr -d '",'
dwm-msg subscribe layout_change_event | while read -r line; do 
	echo "$line " | grep "new_symbol" | awk '{print $2}'  | tr -d '",'
done
