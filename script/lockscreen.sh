#!/usr/local/bin/bash
# Locks the screen.
#

# Get theme color
source "$HOME/.cache/wal/colors.sh"
hex="${color3:1}10"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sudo zzz && i3lock -c "$hex" && $SCRIPT_DIR/startup.sh

