#!/bin/bash
# File: cpu_usage.sh
# Read initial CPU stats for all cores
stat1=$(grep '^cpu[0-9]' /proc/stat)
sleep 0.1
stat2=$(grep '^cpu[0-9]' /proc/stat)

# Calculate average CPU usage across cores
usage=$(echo "$stat1\n$stat2" | awk '
  /^cpu[0-9]/ {
    if (p[$1]) {
      split(p[$1], prev); split($0, curr)
      total_diff = 0; idle_diff = 0
      for (i = 2; i <= 10; i++) total_diff += curr[i] - prev[i]
      idle_diff = curr[5] - prev[5]
      if (total_diff > 0) usage = (1 - idle_diff/total_diff) * 100
      sum += usage; count++
    }
    p[$1] = $0
  }
  END {if (count > 0) printf "%.2f", sum/count}'
)

printf "%.2f" "$usage"
