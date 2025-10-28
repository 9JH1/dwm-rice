if [ "$1" = "--toggle" ];then 
	if [ -n "$(pgrep 'polybar')" ];then 
		echo "polybar is running. killing.."
		killall polybar 
		exit
	fi 
	echo "polybar not running. starting.." 
fi

source ~/.cache/wal/colors.sh
opacity="80"
background_transparent="#$opacity${background:1}"
border_color=$color4
level0=$color1 
level1=$color2  
level2=$color3 
level3=$color6
foreground_alt=$color0
foreground=$color4
accent=$color1

#: accent module padding
padding_num=10
padding="%{O$padding_num}"

polybar_height=30;
polybar_border_size=3;
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"



read -r -d '' POLYBAR_FONT_CONFIG << EOM
font-3 = "MonaspaceRN NFM:style=Bold:size=15;3.2"      
font-2 = "Mononoki Nerd Font:style=Regular:size=15;3.2"      
font-1 = "Victor Mono Nerd Font:style=Bold Italic:size=13;4"
font-0 = "Mononoki Nerd Font:style=Bold:size=14;4"         
dpi = 100
height = $(echo "$polybar_height")px
border-size = $(echo "$polybar_border_size")px
line-size = 2
background = $background_transparent
module-margin = 1.5
border-color = $border_color
foreground = $foreground
fixed-center = true
padding = 20px
enable-ipc=true
EOM

read -r -d '' POLYBAR_HIGHLIGHT_MODULE << EOM 
format-prefix = "$padding"
format-suffix = "$padding"
format-foreground = $foreground_alt
format-background = $border_color 
EOM

read -r -d '' POLYBAR_CONFIG << EOM
[bar/bar_main]
modules-left = powermenu xworkspaces 
modules-center = xwindow
modules-right = network systray date
$POLYBAR_FONT_CONFIG

[bar/bar_dock]
bottom =  true 
modules-left = audio load
modules-center = playerctl
modules-right = notify ram cpu
override-redirect = true 
$POLYBAR_FONT_CONFIG


[module/notify]
type=custom/ipc 
hook-0 =echo "%{T3}\$($SCRIPT_DIR/notify.sh)%{T-}"
initial = 1 
format = <output>
click-left = "dunstctl set-paused toggle && polybar-msg action notify hook 0"
$POLYBAR_HIGHLIGHT_MODULE

[module/ram]
type=internal/memory
interval=5
warn-percentage=95 
label = %percentage_used%%
label-warn = !%free% left
bar-used-indicator = 
bar-used-width = 6
bar-used-foreground-0 = $level0 
bar-used-foreground-1 = $level1 
bar-used-foreground-2 = $level2 
bar-used-foreground-3 = $level3
bar-used-fill = "%{T3}█%{T-}" 
bar-used-empty = "%{T3}█%{T-}" 
bar-used-empty-foreground = $accent
format = "%{T3} %{T-}<label> <bar-used>"

[module/cpu]
type=internal/cpu
interval = 5
warn-percentage = 95
label-warn = "%percentage%%"
label = "%percentage%%"
bar-load-indicator = 
bar-load-width = 6
bar-load-foreground-0 = $level0 
bar-load-foreground-1 = $level1 
bar-load-foreground-2 = $level2 
bar-load-foreground-3 = $level3
bar-load-fill = "%{T3}█%{T-}" 
bar-load-empty = "%{T3}█%{T-}" 
bar-load-empty-foreground = $accent

format = "%{T3} %{T-}<label> <bar-load>"
$POLYBAR_HIGHLIGHT_MODULE

[module/playerctl]
type = custom/ipc
hook-0 = "$SCRIPT_DIR/playerctl.sh"
initial = 1
click-left = playerctl previous && polybar-msg action playerctl hook 0 > /dev/null
click-middle = playerctl play-pause && polybar-msg action playerctl hook 0 > /dev/null 
click-right = playerctl next && polybar-msg action playerctl hook 0 > /dev/null
format ="%{T3}<output>%{T-}"
format-foreground = $accent

[module/audio]
type = internal/pulseaudio
label-volume = "%percentage%%"
label-muted = "%{T3}󰖁 %{T-}"
ramp-volume-0 = "%{T3}󰕿 %{T-}"
ramp-volume-1 = "%{T3}󰖀 %{T-}"
ramp-volume-2 = "%{T3}󰕾 %{T-}"
format-volume = "<ramp-volume><label-volume>"
format-volume-prefix = $padding
format-volume-suffix = $padding 
format-volume-background = $border_color 
format-volume-foreground = $background

format-muted-prefix = $padding  
format-muted-suffix = $padding
format-muted-background = $border_color
foramt-muted-foreground = $background

[module/load]
type = custom/script 
exec = "$SCRIPT_DIR/load.sh"
interval = 5
label = %output%
format = "<label>"

[module/network]
type = internal/network
interface = enp5s0
label-connected = "%upspeed% | %downspeed%"
interval = 5
format-connected = "<label-connected>"
format-connected-prefix = $padding 
format-connected-suffix = $padding 
format-connected-background = $border_color 
format-connected-foreground = $background

[module/systray]
type = internal/tray
tray-spacing = 4pt
tray-size = 25
tray-foreground = $module_foreground

[module/date]
type = internal/date
interval = 1
date = "%{T3}󰃭 %{T-}%l:%M"
date-alt = "%{T3}󰃭 %{T-}%B %d, %Y"
$POLYBAR_HIGHLIGHT_MODULE

[module/powermenu]
type = custom/script
exec = ~/.dwm/src/symbol.sh
format = %{T2}<label>%{T-}
tail = true
$POLYBAR_HIGHLIGHT_MODULE

[module/xworkspaces]
type = custom/script
exec = $SCRIPT_DIR/workspace.sh
tail = true
label = %output%
format = <label>

[module/xwindow]
type = internal/xwindow
label = "%{T2}%instance%%{T-}"
label-padding = 0
label-maxlen = 70 
format = "<label>"
label-empty = "Desktop"
format-foreground = $accent
EOM

POLYBAR_CONFIG_PATH=$(mktemp --suffix=".ini")
echo "$POLYBAR_CONFIG" > "$POLYBAR_CONFIG_PATH"
if [[ "$1" == "no-run" ]]; then 
	exit 
fi



pkill -TERM polybar

polybar -c "$POLYBAR_CONFIG_PATH" bar_main & 
polybar -c "$POLYBAR_CONFIG_PATH" bar_dock &

# start ipc loop 
while [ 1 ];do 
	 polybar-msg action playerctl hook 0
	 sleep 1
done 
