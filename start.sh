cat config.def.h > config.h 
sudo make clean install 
rm -f dwm dwm-msg 

dwm_conf="/tmp/dwm_log_out"
cd ~
startx > "$dwm_conf"
cd -
