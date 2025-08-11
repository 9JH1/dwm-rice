#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export ZDOTDIR="$SCRIPT_DIR/../conf/"
exec zsh 
