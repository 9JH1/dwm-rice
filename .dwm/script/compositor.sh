#!/bin/bash 
# kills picom if its already running 
# or starts picom if its not running
# OR if the --restart flag is run 
# with then picom will only be 
# started 
#
# Are code comments even neccercery?

start(){ picom --config ~/.dwm/config/picom.conf; }
stop(){ killall picom; }
restart(){ stop && start && exit; }

[ "$1" = "--restart" ] && restart

if pgrep -x "picom" &>/dev/null; then 
	stop
else 
	start
fi

