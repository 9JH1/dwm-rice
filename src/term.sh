#!/bin/bash

isolate=0;
[[ "$1" == "-isolate" ]] && isolate=1;

[[ "$1" == "no-run" ]] && exit

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ~/.cache/wal/colors.sh

st_args=();
[[ $isolate -eq 1 ]] && st_args=(-c "iso_term");

st_args+=(
    -f "Terminus:size=15"
    -e bash -c "export ZDOTDIR='$SCRIPT_DIR/../conf/' && export ZSH_ISOLATE=$isolate && exec zsh"
)


echo "Running: st ${st_args[*]}"
exec st "${st_args[@]}"
