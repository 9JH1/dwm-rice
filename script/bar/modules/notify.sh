#!/bin/bash
# Uses dunstctl to display weather or not notifications 
# are activated or not. you can use 
# dunstctl set-paused toggle 
# to toggle this value.  
#


prefix="%{F$1 T1}N%{F- T-}"
if [ $(dunstctl is-paused) = "true" ];then
	echo -n "$prefix off ($(dunstctl count waiting))";
else
  echo -n "$prefix on";
fi
