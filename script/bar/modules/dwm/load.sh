#!/usr/local/bin/bash 
# Get the uptime.. pretty basic 
# 

load=$(uptime | tr ':' '\n' | tail -n 1 | tr -d ',')
load="${load:1}"
echo "^c$1^L^d^ $load"
