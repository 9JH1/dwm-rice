#!/bin/bash

# get # of picom instances
picom=$(($(ps aux | grep "picom" | wc -l)-1))

if [ $picom -gt 0 ]; then killall picom 
else picom --config "/home/_3hy/.dwm/conf/picom.conf"; fi
