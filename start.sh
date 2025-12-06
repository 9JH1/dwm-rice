#!/bin/bash


function build_suckless ()
{
	sudo cat config.def.h > config.h
	sudo make clean install 
}

cd code/dwm
build_suckless
rm -f dwm dwm-msg 
cd - 

cd code/dmenu 
build_suckless
cd -

cd code/st
build_suckless

cd ~
startx
cd -
