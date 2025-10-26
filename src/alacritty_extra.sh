#!/bin/bash

CONFIG="/tmp/alacritty-extra.toml"
touch "$CONFIG"

padding_amount=20
opacity_level=100
padding_set=false
opacity=false
picom=false 

# Read current values
if grep -q "[window.padding]" "$CONFIG"; then
  padding_set=true
fi

if grep -q "#opacity" "$CONFIG"; then
  picom=true 
fi

if grep -q "[window]" "$CONFIG"; then 
	opacity=true 
fi 

function write(){
	if $padding_set; then
  	echo "[window.padding]" > "$CONFIG"
    echo "y=$padding_amount" >> "$CONFIG"
    echo "x=$padding_amount" >> "$CONFIG"
	else 
		echo "" > "$CONFIG"
	fi

	if $opacity; then 
		echo "[window]" >> "$CONFIG"
		echo "opacity = $opacity_level" >> "$CONFIG" 
	fi

	if $picom; then 
		echo "#opacity" >> "$CONFIG"
	fi
}

if [[ $1 == "-padding" ]]; then
  echo "changing padding"
	if $padding_set;then 
		padding_set=false
	else 
		padding_set=true
	fi
	write 

elif [ "$1" == "-selector" ];then 
	opacity_level=$(echo -e "0.0\n0.1\n0.2\n0.3\n0.4\n0.5\n0.6\n0.7\n0.8\n0.9\n1.0" | fzf --prompt="Select opacity: " --height=10)
	write 

else 
  if $picom; then
		killall picom
		picom=false
	else 
		(picom --config ~/.dwm/conf/picom.conf &>/dev/null) &
		picom=true
  fi

	write
fi

