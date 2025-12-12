#!/bin/bash 
uptime | tr ' ' '\n' | tail -n 3 | tr -d ','
