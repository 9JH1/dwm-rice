#!/bin/bash
# Start terminal with tmux or 
# in iso_term class without tmux
# 

isolate=0;

# Determine flags
[[ "$1" == "-isolate" ]] && isolate=1;
[[ "$1" == "no-run" ]] && exit;

# Set mode arguments 
st_args=();

[[ $isolate -eq 1 ]] && { 
	st_args+=(-c "iso_term");	
} || {
	st_args+=(-e bash -c "export TMUX_SF=1 && bash") 
}

# Run terminal with args 
exec st "${st_args[@]}"
