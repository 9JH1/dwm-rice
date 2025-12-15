#!/usr/bin/env bash
# Starts dmenu.
# no need for an xrdb patch 
# when you can easily set the 
# values on launch instead.
# use dmenu patch from in the 
# ../source/dmenu folder as some
# of these flags require a patched 
# version.

source ~/.cache/wal/colors.sh
opacity_hex="30"
background_opacity=$(echo $background)$opacity_hex 
size=700;

dmenu_run \
	-z $size \
	-x $(((1920-$size)/2)) \
	-y 300 \
	-l 15 \
	-fn "Terminus:size=18" \
	-nb "$background" \
	-nf "$foreground" \
	-sb "$color6" \
	-sf "$background" \
	-nhb "$background" \
	-nhf "$color6" \
	-shb "$color6" \
	-shf "$background" 
