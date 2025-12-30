#!/usr/local/bin/bash
mypid=$$

source ~/.cache/wal/colors.sh
background=$color0
foreground=$color7
accent=$color6
mut=$(mktemp)

# Main Variables 
MOD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/modules


echo "using tmp file $mut"

bar_1(){
	SEP="^c$color1^ | ^d^"
	while [ -e "$mut" ];do
		# Modules 
		CPU=$($MOD/dwm/cpu.sh $accent)
		RAM=$($MOD/dwm/ram.sh $accent)
		TIME=$($MOD/dwm/time.sh $accent)
		LOAD=$($MOD/dwm/load.sh $accent)

		# Set status lists
		stat="$CPU$SEP$RAM$SEP$LOAD$SEP$TIME"
		xsetroot -name " $stat "

		sleep 3
	done
}

bar_2(){
	SEP="%{F$color1} | %{F-}"
	while [ -e "$mut" ] ; do
		MEDIA_ICON=$($MOD/media_icon.sh $accent)
		MEDIA_PLAYER=$($MOD/media.sh $accent)
		VOLUME=$($MOD/volume.sh $accent)
		NOTIFY=$($MOD/notify.sh $accent)
		LOCALE=$($MOD/locale.sh $accent)
		DISK=$($MOD/disk.sh $accent)
		
		# Set bar lists
		left="$MEDIA_ICON$SEP$VOLUME"
		right="$LOCALE$SEP$NOTIFY$SEP$DISK"
		echo "%{l} $left%{c}$MEDIA_PLAYER%{r}$right "
		
		sleep 3
	done
}

# Bar calculations
BAR_H=30 # Value with gaps
BAR_W=$((1920-(GAP*2)))
BAR2_GEOM="$BAR_W"x"$BAR_H+0+0"

# Kill old bar
killall lemonbar &>/dev/null
for pid in $(ps aux |  grep "${0##*/}" | awk '{print $2}'); do
    # Avoid killing the current script
    if [ "$pid" -ne "$mypid" ]; then
        kill "$pid" && echo "Killed Pid: $pid"
    fi
done 


sleep 0.1

# Startup new bars
bar_1 &
bar_2 | lemonbar \
	-g "$BAR2_GEOM" \
	-d -b \
	-n "$bar_2_id" \
	-B "$background" \
	-f "Terminus (TTF):style=Italic:size=16" &

wait
echo "Exiting.."
rm "$mut"
