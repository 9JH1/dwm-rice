#!/bin/bash
set -x
rm config.h
cat config.def.h > config.h
sudo make clean install
set +x
git add . 
git commit -m "auto_dwm_$(date)"
git push
