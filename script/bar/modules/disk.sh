#!/bin/bash
# Print disk available
#

avail=$(df -h | grep "/$" | awk '{printf $4}')
echo "%{F$1 T1}D%{F- T-} $avail"
