#!/bin/bash
dwm-msg subscribe monitor_focus_change_event | while IFS= read -r line; do 
	if [[ "$line" == *"new_monitor_number"* ]];then 
		echo $line | awk '{print $2}'
	fi 
done
