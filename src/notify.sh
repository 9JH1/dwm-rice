#!/bin/bash
#set-paused
#is-paused
if [ $(dunstctl is-paused) = "true" ];then
    echo -n "󰂛 %{T1}off%{T-}";
else
    echo -n " %{T2}on%{T-} ";
fi
