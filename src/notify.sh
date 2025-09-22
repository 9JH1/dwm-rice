#!/bin/bash
if [ $(dunstctl is-paused) = "true" ];then
	echo -n "󰂛 %{T1}off ($(dunstctl count waiting))%{T-}";
else
  echo -n " %{T2}on%{T-} ";
fi
