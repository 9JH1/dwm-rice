#!/usr/local/bin/bash
# Attempts for forcefully quit a program 
# as sometimes apps catch the quit signal 
# and take their time to close down. this 
# script will FORCEFULLY TERMINATE any program 
# that is being hovered.
#
# xprop is required for this to work!
#

# get pid of current client
win_id=$(xprop -root _NET_ACTIVE_WINDOW | tr ' ' '\n' | tail -n 1)
pid=$(xprop -id "$win_id" _NET_WM_PID | awk '{print $3}')

# kill signal 
if [ -n "$pid" ]; then
    kill -9 "$pid"
	kill -term "$pid"
	pkill -ns "$pid"
fi
