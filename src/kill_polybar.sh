#!/bin/bash

# Maximum number of attempts to kill polybar
MAX_ATTEMPTS=10
ATTEMPT=1
killall -q polybar

# Check for polybar processes and attempt to kill them
while pgrep -x polybar > /dev/null; do
    if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
        echo "Failed to terminate polybar after $MAX_ATTEMPTS attempts."
        exit 1
    fi

    echo "Killing polybar processes (attempt $ATTEMPT)..."
    # Try graceful termination first
    pkill -x polybar 2>/dev/null
    # Wait briefly to allow processes to exit
    sleep 0.2

    # If processes still exist, force kill
    if pgrep -x polybar > /dev/null; then
        echo "Force killing polybar processes..."
        pkill -9 -x polybar 2>/dev/null
        sleep 0.2
    fi

    ((ATTEMPT++))
done

echo "All polybar processes terminated successfully."
