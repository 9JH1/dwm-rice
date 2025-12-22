#!/bin/bash
mypid=$$
for pid in $(pgrep -f ${0##*/}); do
	[[ $pid -ne $mypid ]] && kill $pid
  sleep 1
done 

# Start the dual lemonbar

source ~/.cache/wal/colors.sh
opacity=90
opacity=$(((opacity * 255) / 100))

# Colors
background="#"$(printf "%X" "$opacity")"${background:1}"
foreground="$color7"
accent=$color8
sep_color=$color1

# Main Variables 
CONT=$(mktemp)
INT=3
PAD=" "
PAT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MOD="$PAT"/modules
WORKSPACE_WIDTH=700;

# Bar calculations
BAR_H=25 # Value with gaps
GAP=0
BAR_W=$((1920-(GAP*2)))
BAR2_GEOM="$BAR_W"x"$((BAR_H-GAP))+$GAP+$GAP"

bar_1(){
	framecount=0;
	SEP="^c$sep_color^ | ^d^"

	# Bar 1 loop 
	while [ -e $CONT ];do 
		# Modules 
		CPU=$($MOD/dwm/cpu.sh $accent)
		RAM=$($MOD/dwm/ram.sh $accent)
		NOTIFY=$($MOD/dwm/notify.sh $accent)
		LOCALE=$($MOD/dwm/locale.sh $accent)
		TIME=$($MOD/dwm/time.sh $accent)
		LOAD=$($MOD/dwm/load.sh $accent)

		stat="$PAD$CPU$SEP$RAM$SEP$LOAD$SEP$NOTIFY$SEP$LOCALE$SEP$TIME$PAD"

		xsetroot -name "$stat"

		framecount=$((framecount+1));
		sleep $INT
	done
}


bar_2(){
	framecount=0;
	SEP=" %{T2}%{F$sep_color}|%{F$foreground}%{T0} "
	
	# Bar 2 loop
	while [ -e $CONT ];do 

		# Modules:
		MEDIA_ICON=$($MOD/media_icon.sh $accent)
		MEDIA_NEXT=$($MOD/media_next.sh $accent)
		MEDIA_PREV=$($MOD/media_prev.sh $accent)
		MEDIA_PLAYER=$($MOD/media.sh $sep_color)
		MONITOR=$($MOD/monitor.sh $accent)
		VOLUME=$($MOD/volume.sh $accent)
		WINDOW=$($MOD/window.sh $accent) 
		NETWORK=$($MOD/net.sh $accent)
		DISK=$($MOD/disk.sh $accent)

		# Set module lists
		left="$PAD$MEDIA_PREV $MEDIA_ICON $MEDIA_NEXT $MEDIA_PLAYER"
		right="$NETWORK$SEP$VOLUME$SEP$DISK$SEP$WINDOW$SEP$MONITOR$PAD"


		# Print bar
		echo "%{l}$left%{r}$right"

		framecount=$((framecount+1));
		sleep $INT
	done
}

# Killall old bars 
killall lemonbar

bar_1 &

bar_2 | \
	lemonbar \
	-g "$BAR2_GEOM" \
	-d -b -o 2 \
	-n "$bar_2_id" \
	-B "$background" \
	-f "Terminus:size=16" \
	-f "Terminus:style=Bold:size=16"&

# Leave both bars running in background

wait
