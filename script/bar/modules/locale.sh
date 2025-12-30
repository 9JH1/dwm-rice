#!/usr/local/bin/bash 
# show locale REQUIRES xkb-switch
# pkg install xkb-switch
#

echo "%{F$1}L%{F-} $(xkb-switch)"
