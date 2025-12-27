#!/usr/local/bin/bash 
# decriment volume 
# 

pactl set-sink-volume @DEFAULT_SINK@ -5%
