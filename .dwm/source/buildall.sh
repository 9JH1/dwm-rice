#!/bin/bash
# Build all projects that have a Makefile

find . -type d | while IFS= read -r dir; do
    [ "$dir" = "." ] && continue
    cd "${dir#./}" && sudo make clean install || {
		echo "Stopped due to error in $dir"
		exit
	}
	cd ..
done
