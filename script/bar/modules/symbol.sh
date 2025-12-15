#!/bin/bash 
# Show symbol from hook 
#

sym="$(cat $HOME/.cache/dwm_symbol_hook.txt)"
echo "%{F$1 T1}$sym%{F- T-}"
