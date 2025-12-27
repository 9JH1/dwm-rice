#!/usr/local/bin/bash

swap_used=$(swapinfo -m | tail -n 1 | awk '{print $3}')
swap_total=$(swapinfo -m | tail -n 1 | awk '{print $2}')

ram_used=$(top -n 1 | grep "Mem" | tr ',' '\n' | head -n 2 | tail -n 1 | awk '{print $1}')
ram_used=${ram_used::-1}

ram_total=$(sysctl hw.physmem | awk '{print $2}')
ram_total=$((ram_total / 1024 / 1024))

used=$(( ram_used + swap_used ))MB
total=$(( ram_total + swap_total ))MB


echo "^c$1^R^d^ $used / $total"

