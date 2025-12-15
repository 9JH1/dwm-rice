#!/bin/bash 
# show ram usage 
#

pkt=$(free -m | head -n 2 | tail -n 1)
used=$(echo $pkt | awk '/Mem/{print $3}');
total=$(echo $pkt | awk '/Mem/{print $2}');

echo "%{F$1 T1}R%{F- T-} $used"MB" / $total"MB""
