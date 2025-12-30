#!/usr/local/bin/bash
# Print disk available
#

avail=$(df -h | grep "/$" | awk '{printf $4}')
echo "%{F$1}D%{F-} $avail"
