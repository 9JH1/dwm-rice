#!/bin/bash 
# Get the uptime.. pretty basic 
# 

load=$(uptime | tr ':' '\n' | tail -n 1 | tr -d ',')
echo "%{F$1 T1}F%{F- T-} $load"
