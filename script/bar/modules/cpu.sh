#!/bin/bash 
# Get average CPU percent and temp
#

cpu=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))

# Get CPU cores 
IFS=')' read -ra core_temp_arr <<< $(sensors -f | grep '^Core\s[[:digit:]]\+:') #echo "${core_temp_arr[0]}"

total_cpu_temp=0
index=0

# Get sum of CPU core temps 
for i in "${core_temp_arr[@]}"; do :
    temp=$(echo $i | sed -n 's/°F.*//; s/.*[+-]//; p; q')
    let index++
    total_cpu_temp=$(echo "$total_cpu_temp + $temp" | bc)
done

# Use either
avg_cpu_temp_f=$(echo "scale=2; $total_cpu_temp / $index" | bc)
avg_cpu_temp_c=$(awk "BEGIN { printf(\"%0.2f\", (($avg_cpu_temp_f - 32) / (9/5))) }")

# Print data
percent=$(printf "%0.2f" "$cpu")

echo "%{F$1 T1}C%{F- T-} $percent% : $avg_cpu_temp_c"°C
