#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
instances=$(($(ps aux | grep "picom" | wc -l)-3))
echo $instances instances of picom found
ps aux | grep "picom"

if [ $instances -gt 0 ]; 
then 
	killall picom 

else 
	picom --config "$SCRIPT_DIR/../conf/picom.conf"; 
fi
