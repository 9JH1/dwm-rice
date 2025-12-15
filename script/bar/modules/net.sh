#!/bin/bash
# Print network speed (average 1s)
#

dev="enp5s0"

# read bytes received now
rx1=$(cat /sys/class/net/"$dev"/statistics/rx_bytes)
sleep 1

rx2=$(cat /sys/class/net/"$dev"/statistics/rx_bytes)
delta=$((rx2 - rx1))
mbps=$(echo "scale=2; $delta / 1024 / 1024" | bc)

echo "%{F$1 T1}ND%{F- T-} $mbps MB/s"
