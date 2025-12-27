#!/bin/sh

echo "This script will remove the following files.."
echo "press any key to continue"
read 
echo -e "$(find ~/.config/)\n$(~/Desktop/)" | less 

echo "press any key to run this, press control+c to quit."
read

if [[ ! "$?" -eq 0 ]]; then 
	exit
fi

rm -r ~/.config 
rm -r ~/Desktop 

ln -s /drive/Docuements ~
ln -s /drive/Pictures ~
ln -s /drive/Videos/ ~ 
ln -s /drive/Applications/ ~
ln -s /drive/Desktop ~
ln -s /drive/Downloads ~
ln -s /drive/config ~/.config
