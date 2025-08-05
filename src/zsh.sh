#!/bin/sh
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_ISOLATE=1

killall 
if ! command -v zsh >/dev/null 2>&1; then
    echo "Error: zsh is not installed" >&2
    exit 1
fi
exec zsh
