#!/usr/bin/env bash
source ~/.cache/wal/colors.sh
opacity_hex="30"
background_opacity=$(echo $background)$opacity_hex 
color2=$(echo $color2)$opacity_hex 
color1=$(echo $color1)$opacity_hex

read -r -d '' ROFI_CONFIG << EOM
* {
	bg0: #00000000;
	bg1: $background_opacity;
	fg0: $color7;
	fg1: $background;
	accent-color: $color3;
	urgent-color: $color1;
	
	font: "Victor Mono Nerd Font Bold Italic 17";	
	//font: "Mononoki Nerd Font 20";
	
	background-color: @bg0;
	text-color: @fg0;

	margin: 0;
	padding:0;
	spacing:0;
}

window {
    location:   center;
    width:      680;
    background-color: @bg1;
		border: 3px;
		border-color: $color5;
}

inputbar {
    spacing:    4px;
    padding:    8px;

    background-color:   @bg1;
		foreground-color:   @fg1; 
}

prompt, entry, element-icon, element-text {
    vertical-align: 0.5;
}

textbox {
    padding:            8px;
    background-color:   @bg1;
}

listview {
    lines:      6;
    columns:    1;
    fixed-height:   false;
}

element {
    padding:    4px 8px;
    spacing:    4px;
}

element normal normal {
    text-color: @fg0;
}

element normal urgent {
    text-color: @urgent-color;
}

element normal active {
    text-color: @accent-color;
}

element alternate active {
    text-color: @accent-color;
}

element selected {
    text-color: @fg1;
}

element selected normal, element selected active {
    background-color:   @accent-color;
}

element selected urgent {
    background-color:   @urgent-color;
}

element-icon {
    size:   1em;
}

element-text {
    text-color: inherit;
}
EOM
ROFI_PATH=$(mktemp --suffix=".rasi")
echo "$ROFI_CONFIG" > "$ROFI_PATH"
rofi -show drun -theme "$ROFI_PATH" -show-icons -display-drun ""  -dpi 100
