#!/bin/bash 
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
polybar -c $SCRIPT_DIR/../conf/polybar.ini bar &
