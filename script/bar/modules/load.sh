#!/bin/bash 
# Get the uptime.. pretty basic 
# 

load=$(uptime | tr ':' '\n' | tail -n 1 | tr -d ',')
load="${load:1}"
echo "%{F$1 T1}L%{F- T-} $load"
