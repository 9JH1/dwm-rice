#!/usr/local/bin/bash 
# Get average CPU percent and temp
#

percent=$(printf "%.2f" $(top -b -n 0 -d 2 | grep "CPU:" | tail -n 1 | awk '{print $2}'))

echo "^c$1^C^d^ $percent"
