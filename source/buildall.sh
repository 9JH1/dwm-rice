#!/bin/bash

cd make
./buildall.sh 
[[ "$?" -ne "0" ]] && exit

cd ../other
./buildall.sh
cd ..
echo "Done"
