#!/bin/bash
win_id=$(xdotool getwindowfocus)
pid=$(xprop -id "$win_id" _NET_WM_PID | awk '{print $3}')

# Force kill the application by PID
if [ -n "$pid" ]; then
    kill -9 "$pid"
		kill -term "$pid"
		pkill -ns "$PID"
fi
