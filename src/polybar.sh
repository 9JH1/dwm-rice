if [ "$1" = "--toggle" ];then 
	if [ -n "$(pgrep 'polybar')" ];then 
		echo "polybar is running. killing.."
		killall polybar 
		exit
	fi 
	echo "polybar not running. starting.." 
fi

source ~/.cache/wal/colors.sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

polybar_height="25px" 
polybar_border="3px"
bg0=$background # background color 
bg1=$background # background surface color 
fg0=$color7     # text color 
fg1=$color1     # alt text colo
ac0=$color5     # accent color 

if [ ! "$1" = "--import" ];then 

read -r -d '' POLYBAR_FONT_CONFIG << EOM
font-2 = "Mononoki Nerd Font:style=Regular:size=16;3"
font-1 = "Victor Mono Nerd Font:style=Bold Italic:size=13;2"
font-0 = "Mononoki Nerd Font:style=Bold:size=14;3"
height = $polybar_height 
border-size = $polybar_border
background = $bg0 
border-color = $ac0
foreground = $fg0 
fixed-center = true
padding = 10px
enable-ipc=true
modules-center = space
EOM

read -r -d '' POLYBAR_CONFIG << EOM
[bar/bar_main]
modules-left = dwm_mark space xworkspaces xwindow
$POLYBAR_FONT_CONFIG

[bar/bar_dock]
bottom =  true 
override-redirect = true 
modules-left = playerctl_ipc playerctl
modules-right = date
$POLYBAR_FONT_CONFIG

[module/space]
type = custom/text 
label = " "

[module/playerctl_ipc]
type = custom/ipc
hook-0 = "$SCRIPT_DIR/playerctl_icon.sh"
initial = 1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
click-middle = playerctl previous
format ="%{T3}<output>%{T-}"

[module/playerctl]
type=custom/script
exec = "$SCRIPT_DIR/playerctl.sh" && polybar-msg action playerctl_ipc hook 0 > /dev/null
format ="<label>"
interval=1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null

[module/date]
type = internal/date
interval = 1
date = "%{T2}%B %d, %Y%{T-}"

[module/xworkspaces]
type = custom/script
exec = "$SCRIPT_DIR/workspace.sh"
tail = true
label = %output%
format = <label>

[module/xwindow]
type = internal/xwindow
label = "%{T2}%instance%%{T-}"
label-padding = 0
label-maxlen = 70 
format-prefix = " "
format = "<label>"
label-empty = "Desktop"
label-underline = $fg0
format-foreground = $fg1 

[module/dwm_mark]
type = custom/script
exec = ~/.dwm/src/symbol.sh
format = %{T2}<label>%{T-}
tail = true
format-foreground = $fg1 
EOM


POLYBAR_CONFIG_PATH=$(mktemp --suffix=".ini")
echo "$POLYBAR_CONFIG" > "$POLYBAR_CONFIG_PATH"
if [[ "$1" == "no-run" ]]; then 
	exit 
fi

pkill -TERM polybar

polybar -c "$POLYBAR_CONFIG_PATH" bar_main & 
polybar -c "$POLYBAR_CONFIG_PATH" bar_dock &
fi
