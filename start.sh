set -xe
cat config.def.h > config.h 
sudo make clean install 
rm -f dwm dwm-msg
cd ~ 
startx
cd -

(git add . && git commit -m "$(date)" && git push) &>/dev/null
