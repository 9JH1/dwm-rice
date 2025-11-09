#!/bin/bash
if [ $(dunstctl is-paused) = "true" ];then
	echo -n "󰂛 %{F-}%{T1} $(dunstctl count waiting)%{T-}";
else
  echo -n " %{F-}%{T2}on%{T-} ";
fi
