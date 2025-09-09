source ~/.cache/wal/colors.sh
opacity="45"
background=$color0 
background_transparent="#$opacity${background:1}"
background_alt=$color3
foreground_alt=$color2
border_color=$color4
primary=$color5
secondary=$color4
module_foreground=$color0
alert="#ff0000"
disabled=$color5
level0=$color0
level1=$color0 
level2=$color7 
level3=$alert 

dwm_border_size=3
dwm_bottom_gap=50
polybar_border_size=4
polybar_height=$((dwm_bottom_gap-(dwm_border_size*2)))
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

read -r -d '' POLYBAR_FONT_CONFIG << EOM
font-3 = "Mononoki Nerd Font:style=Regular:size=21;6.6)"
font-2 = "Mononoki Nerd Font:style=Regular:size=15;3.2"
font-1 = "Victor Mono Nerd Font:style=Bold Italic:size=13;4"
font-0 = "Mononoki Nerd Font:style=Bold:size=14;4"
dpi = 150
height = $(echo "$polybar_height")px
border-size = $(echo "$polybar_border_size")px
line-size = 2
background = $background_transparent
border-color = $color4
foreground = $module_foreground
fixed-center = true
padding = 20px
enable-ipc=true
EOM

read -r -d '' POLYBAR_CONFIG << EOM
[bar/bar_main]
modules-left = left_prefix powermenu powermenu_seperator xworkspaces xworkspaces_seperator xwindow left_suffix
modules-right = right_prefix notify notify_seperator systray tray_seperator date right_suffix
$POLYBAR_FONT_CONFIG

[bar/bar_dock]
bottom =  true 
modules-left = right_prefix playerctl_ipc playerctl playerctl_next playerctl_seperator audio dock_right_suffix
modules-right = dock_prefix network network_seperator ram ram_seperator cpu dock_suffix 
override-redirect = true 
$POLYBAR_FONT_CONFIG

[module/dock_prefix]
type=custom/text
label = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color1

[module/notify]
type=custom/ipc 
hook-0 =echo "%{T3}\$($SCRIPT_DIR/notify.sh)%{T-}"
initial = 1 
format = <output>
click-left = "dunstctl set-paused toggle && polybar-msg action notify hook 0"
format-background = $color1
format-foreground = $color7
format-prefix = " "
format-suffix = " "

[module/notify_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2
format-background=$color1 

[module/ram]
type=internal/memory
interval=5
warn-percentage=95 
label = %percentage_used%%
format = "%{T3}  %{T-}<label> <bar-used>"
format-background = $color2
format-foreground = $module_foreground
label-warn = !%free% left
format-warn = "%{T3} %{T-}<label-warn> <label-warn>"
bar-used-indicator = 
bar-used-width = 6
bar-used-foreground-0 = $level0 
bar-used-foreground-1 = $level1 
bar-used-foreground-2 = $level2 
bar-used-foreground-3 = $level3
bar-used-fill = "%{T3}▐%{T-}" 
bar-used-empty = "%{T3}▐%{T-}" 
bar-used-empty-foreground = $color1
format-suffix = " "

[module/ram_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color3
format-background=$color2  

[module/cpu]
type=internal/cpu
interval = 5
warn-percentage = 95
label-warn = "%percentage%%"
format-warn = "%{T3} %{T-}<label-warn> <bar-load>"
format-background = $color3 
format-foreground = $module_foreground
format-warn-foreground = $alert
format-warn-background = $color3 
label = "%percentage%%"
bar-load-indicator = 
bar-load-width = 6
bar-load-foreground-0 = $level0 
bar-load-foreground-1 = $level1 
bar-load-foreground-2 = $level2 
bar-load-foreground-3 = $level3
bar-load-fill = "%{T3}▐%{T-}" 
bar-load-empty = "%{T3}▐%{T-}" 
bar-load-empty-foreground = $color2
format = "%{T3} %{T-}<label> <bar-load>"
format-suffix = " "

[module/dock_suffix]
type = custom/text 
format = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color3


[module/right_prefix]
type=custom/text
label = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color1

[module/playerctl_next]
type=custom/text
label = "%{T3}󰒭%{T-}"
click-left = playerctl next
format = "<label>"
format-foreground = $module_foreground
format-background = $color1
format-prefix = " "
format-suffix = " "

[module/playerctl_ipc]
type = custom/ipc
hook-0 = "$SCRIPT_DIR/playerctl_icon.sh"
initial = 1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
click-middle = playerctl previous
format ="%{T3}<output>%{T-}"
format-foreground = $module_foreground
format-background = $color1

[module/playerctl]
type=custom/script
exec = "$SCRIPT_DIR/playerctl.sh" && polybar-msg action playerctl_ipc hook 0 > /dev/null
format ="<label>"
interval=1
format-prefix = " " 
format-suffix = " "
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
format-foreground = $color7
format-background = $color1

[module/playerctl_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2
format-background = $color1

[module/audio]
type = internal/pulseaudio
format-volume = <ramp-volume><label-volume>
label-volume = "%percentage%%"
label-muted = "%{T3}󰖁 %{T-}"
format-muted-background=$color2 
format-volume-background=$color2 
format-muted-foreground = $module_foreground
format-volume-foreground=$module_foreground
ramp-volume-0 = "%{T3}󰕿 %{T-}"
ramp-volume-1 = "%{T3}󰖀 %{T-}"
ramp-volume-2 = "%{T3}󰕾 %{T-}"
format-volume-prefix = " "
format-volume-suffix = " "
format-muted-prefix = " "
format-muted-suffix = " "


[module/audio_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2
format-background=$color1

[module/network]
type = internal/network
interface = enp5s0
format-connected-background = $color1 
format-connected-foreground = $color7 
label-connected = "%{T3} %{T-}%upspeed% %{T3} %{T-}%downspeed% "
interval = 5

[module/network_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2 
format-background=$color1

[module/systray]
type = internal/tray
tray-spacing = 4pt
format-prefix = " " 
format-suffix = " "
tray-size = 25
format-background = $color2  
tray-background= $color2 
format-foreground = $module_foreground
tray-foreground = $module_foreground

[module/tray_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color3 
format-background=$color2 

[module/date]
type = internal/date
interval = 1
format-foreground = $module_foreground
format-background = $color3 
date = "%{T3}󰃭 %{T-}%{T2}%l:%M%{T-} "
date-alt = "%{T3}󰃭 %{T-}%{T2}%d/%m/%Y%{T-} "
[module/right_suffix]
type=custom/text
label = "%{T4}%{T-}"
format-background=$background_transparent
format-foreground = $color3

[module/dock_right_suffix]
type=custom/text
label = "%{T4}%{T-}"
format-background=$background_transparent
format-foreground = $color2

[module/left_prefix]
type = custom/text 
format = "%{T4}%{T-}"
format-background = $background_transparent 
format-foreground = $color1 

[module/powermenu]
type = custom/script
exec = ~/.dwm/src/symbol.sh
format = %{T2}<label>%{T-}
tail = true
click-left = ~/.dwm/src/jgmenu.sh
format-foreground = $color7
format-background = $color1

[module/powermenu_seperator]
type=custom/text
label = "%{T4}%{T-}"
format-background = $color2 
format-foreground = $color1

[module/xworkspaces_OLD]
icon-0 = 1;󰲡
icon-1 = 2;󰲣
icon-2 = 3;󰲥
icon-3 = 4;󰲧
icon-4 = 5;󰲩
icon-5 = 6;󰲫
icon-6 = 7;󰲭
icon-7 = 8;󰲯
icon-8 = 9;󰲱

type = internal/xworkspaces
label-active = %icon%
label-urgent = 
label-visible = 
label-empty =  
label-occupied = 

label-active-padding = 1
label-active-underline = $color0
label-occupied-padding = 1
label-urgent-underline = $alert
label-urgent-padding = 1
label-empty-padding = 1
format-prefix = " "
format-suffix = " "
format-foreground = $module_foreground
format-background = $color2 
workspace-count = 10

[module/xworkspaces]
type = custom/script
exec = $SCRIPT_DIR/workspace.sh
tail = true
format-foreground = $module_foreground
format-background = $color2
label = %output%
format = <label>

[module/xworkspaces_seperator]
type=custom/text
label = "%{T4}%{T-}"
format-background = $color3
format-foreground = $color2 

[module/xwindow]
type = internal/xwindow
label = "%{T2}%class%%{T-}"
label-padding = 0
label-maxlen = 20 
format-prefix = " "
format = "<label>"
format-foreground = $module_foreground
format-background = $color3
label-empty = "Desktop"
label-underline = $module_foreground

[module/left_suffix]
type=custom/text
label = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color3
EOM


POLYBAR_CONFIG_PATH=$(mktemp --suffix=".ini")
echo "$POLYBAR_CONFIG" > "$POLYBAR_CONFIG_PATH"
if [[ "$1" == "no-run" ]]; then 
	exit 
fi

pkill -TERM polybar

polybar -c "$POLYBAR_CONFIG_PATH" bar_main & 
polybar -c "$POLYBAR_CONFIG_PATH" bar_dock &
