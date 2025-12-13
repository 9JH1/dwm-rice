#!/bin/bash 
# Uses playerctl to display playing status
#

if [ $(playerctl status) == "Playing" ]; then
	echo -e " "
else 
	echo -e " "
fi
