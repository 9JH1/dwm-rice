#!/bin/bash
set -x
rm config.h
cat config.def.h > config.h
sudo make clean install
cd dwmblocks 
rm blocks.h 
cat blocks.def.h > blocks.h
sudo make clean install 
cd ..
set +x
git add . 
git commit -m "auto_dwm_$(date)"
git push
