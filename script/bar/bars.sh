#!/bin/bash
# Start the dual lemonbar

source ~/.cache/wal/colors.sh
opacity=90
opacity=$(((opacity * 255) / 100))

# Colors
background="#"$(printf "%X" "$opacity")"${background:1}"
foreground=$foreground
accent=$color8
sep_color=$color1

# Main Variables 
CONT=$(mktemp)
INT=3
PAD=" "
SEP=" %{T2}%{F$sep_color}|%{F$foreground}%{T0} "
MOD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/modules
WORKSPACE_WIDTH=700;

# Bar calculations
BAR_H=35 # Value with gaps
BORDER=0
GAP=0
BAR_W=$((1920-(GAP*2)))
BAR1_GEOM="$BAR_W"x"$((BAR_H-GAP+BORDER))+$GAP+$GAP"
BAR2_GEOM="$BAR_W"x"$((BAR_H-GAP+BORDER+BORDER))+$GAP+$GAP"
BAR3_GEOM="$WORKSPACE_WIDTH"x"$((BAR_H-GAP+BORDER))+$(((1920-$WORKSPACE_WIDTH)/2))+$GAP"

bar_1(){
	framecount=0;

	# Bar 1 loop 
	while [ -e $CONT ];do 

		# Modules 
		SYMBOL=$($MOD/symbol.sh $accent)
		CPU=$($MOD/cpu.sh $accent)
		RAM=$($MOD/ram.sh $accent)
		NOTIFY=$($MOD/notify.sh $accent)
		LOCALE=$($MOD/locale.sh $accent)
		TIME=$($MOD/time.sh $accent)
		LOAD=$($MOD/load.sh $accent)

		left="$PAD$SYMBOL$SEP$CPU$SEP$RAM"
		right="$SEP$LOAD$SEP$NOTIFY$SEP$LOCALE$SEP$TIME$PAD"

		echo "%{l}$left%{r}$right"

		framecount=$((framecount+1));
		sleep $INT
	done
}


bar_2(){
	framecount=0;
	
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

# Launch symbol hook 
$MOD/symbol_hook.sh "$CONT" & 

bar_1_id="$(mktemp)"
# Launch bars
bar_1 | \
	lemonbar \
	-g "$BAR1_GEOM" \
	-d \
	-n "$bar_1_id" \
	-B "$background" \
	-f "Terminus:size=16" \
	-f "Terminus:style=Bold:size=16" &

bar_2_id="$(mktemp)"
bar_2 | \
	lemonbar \
	-g "$BAR2_GEOM" \
	-d -b\
	-n "$bar_2_id" \
	-B "$background" \
	-f "Terminus:size=16" \
	-f "Terminus:style=Bold:size=16"&

sleep 0.5

# workspace bar 
$MOD/workspaces.sh | \
	lemonbar \
	-g "$BAR3_GEOM" \
	-d \
	-B "#00000000" \
	-f "Terminus:size=16" \
	-f "Terminus:style=Bold:size=16" &

# Tray bar 
BAR_WID="$(xdotool search --name "$bar_1_id" | head -n 1)"
snixembed --container "$BAR_WID" --position right &

# Leave both bars running in background

exit_handle(){
	echo "Exiting"
	command rm "$CONT"
	command rm "$bar_1_id"
	command rm "$bar_2_id"
	exit
}

trap exit_handle SIGINT

wait
