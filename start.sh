set -xe
cat config.def.h > config.h 
sudo make clean install 
rm -f dwm dwm-msg
startx
