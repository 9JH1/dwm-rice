#!/bin/bash 
# prints the current selected window
#

title="";
len=30
len_s="30s"

get_title(){
	wid=$(xdotool getactivewindow | head -n 1)
	title=$(xprop -id $wid WM_NAME | tr '"' '\n' | head -n 2 | tail -n 1)
	title=$(echo "$title" | '-' '\n' | tail -n 1)  
	title=$(echo "$title" | awk "{if(length > $len) printf \"%.$len_s...\n\", \$0; else print}")
}


get_title &>/dev/null 

if [ -v $title ];then
	title="Desktop"
fi

echo "%{F$1 T1}W%{T- F-} $title"
