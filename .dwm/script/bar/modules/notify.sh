#!/bin/bash
# Uses dunstctl to display weather or not notifications 
# are activated or not. you can use 
# dunstctl set-paused toggle 
# to toggle this value.  
#

if [ $(dunstctl is-paused) = "true" ];then
	echo -n "󰂛 %{F-}%{T1} $(dunstctl count waiting)%{T-}";
else
  echo -n " %{F-}%{T2}on%{T-} ";
fi
