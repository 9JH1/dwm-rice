#!/bin/bash
# Uses dwm-msg to display the current focused mon idx 
# then uses xrandr to get the monitors name.
#

dwm-msg subscribe monitor_focus_change_event | while IFS= read -r line; do 
	if [[ "$line" == *"new_monitor_number"* ]];then 
		mon_num=$(echo $line | awk '{print $2}')
		mon_name=$(xrandr | grep "connected" | head -n $((mon_num + 1)) | tail -n 1 | awk '{print $1}')
		echo "$mon_name"
	fi 
done
