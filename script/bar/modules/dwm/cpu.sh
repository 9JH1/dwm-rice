#!/usr/local/bin/bash 
# Get average CPU percent and temp
#

percent=$(top -n 1 | grep "CPU:" | awk '{print $2}')

echo "^c$1^C^d^ $percent"
