#!/bin/bash 
# Get the uptime.. pretty basic 
# 


# Show only 1 min average 
# uptime | tr ' ' '\n' | tail -n 3 | tr -d ','

# Show all 3 loadtimes                   # remove commas 
echo $(uptime | tr ':' '\n' | tail -n 1 | tr -d ',')
