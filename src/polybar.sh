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
level0=$color4 
level1=$color5 
level2=$color6
level3=$alert

read -r -d '' POLYBAR_FONT_CONFIG << EOM 
font-4 = "Mononoki Nerd Font:style=Regular:size=18;5.2"
font-3 = "Mononoki Nerd Font:style=Regular:size=25;5.1"
font-2 = "Mononoki Nerd Font:style=Regular:size=16;2.1"
font-1 = "Victor Mono Nerd Font:style=Bold Italic:size=13;2.5"
font-0 = "Mononoki Nerd Font:style=Bold:size=13;2.1"
dpi = 130
height = 4%
border-size = 2pt
line-size = 2
background=$background_transparent
border-color = $color4
foreground = $module_foreground
fixed-center = true
padding = 10pt
EOM

read -r -d '' POLYBAR_CONFIG << EOM
[bar/bar_main]
modules-left = left_prefix powermenu powermenu_seperator xworkspaces xworkspaces_seperator polywins left_suffix
modules-right = right_prefix playerctl_prev playerctl_ipc playerctl playerctl_next playerctl_seperator audio audio_seperator notify notify_seperator systray tray_seperator date right_suffix
enable-ipc=true
$POLYBAR_FONT_CONFIG

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
format-background = $color1
format-foreground = $module_foreground
format-prefix = " "
format-suffix = " "

[module/playerctl_prev]
type=custom/text
label = "%{T3}󰒮%{T-}"
click-left = playerctl previous
format = "<label>"
format-suffix = " "
format-background = $color1
format-foreground = $module_foreground

[module/playerctl_ipc]
type = custom/ipc
hook-0 = echo "\$($HOME/.dwm/src/playerctl_icon.sh)"
initial = 1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
format ="%{T3}<output>%{T-}"
format-background = $color1
format-foreground = $module_foreground

[module/playerctl]
type=custom/script
exec = $HOME/.dwm/src/playerctl.sh & polybar-msg action playerctl_ipc hook 0 > /dev/null
format ="<label>"
interval=1
format-prefix = " " 
format-suffix = " "
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
format-background = $color1
format-foreground = $module_foreground

[module/playerctl_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2
format-background=$color1 

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
format-foreground=$color3 
format-background=$color2

[module/notify]
type=custom/ipc 
hook-0 =echo "%{T3}\$($HOME/.dwm/src/notify.sh)%{T-}"
initial = 1 
format = <output>
click-left = "dunstctl set-paused toggle && polybar-msg action notify hook 0"
format-background = $color3
format-foreground = $module_foreground
format-prefix = " "
format-suffix = " "

[module/notify_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color1
format-background=$color3

[module/dock_prefix]
type=custom/text
label = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color1

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

[module/cpu_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color3 
format-background=$color2


[module/network]
type = internal/network
interface = enp5s0
format-connected-background = $color1 
format-connected-foreground = $module_foreground 
label-connected = %{T3} %{T-}%upspeed% %{T3} %{T-}%downspeed%
interval = 5

[module/network_seperator]
type=custom/text
label = "%{T4}%{T-}"
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

[module/dock_suffix]
type = custom/text 
format = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color3 

[module/systray]
type = internal/tray
tray-spacing = 4pt
format-prefix = " " 
format-suffix = " "
tray-size = 20
format-background = $color1
tray-background= $color1
format-foreground = $module_foreground
tray-foreground = $module_foreground

[module/tray_seperator]
type=custom/text
label = "%{T4}%{T-}"
format = <label>
format-foreground=$color2
format-background=$color1

[module/date]
type = internal/date
interval = 1
format-foreground = $module_foreground
format-background = $color2
date = "%{T3}󰃭 %{T-}%{T2}%l:%M:%S%{T-}"
date-alt = %d/%m/%Y

[module/right_suffix]
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
format = <label>
tail = true
click-left = ~/.dwm/src/jgmenu.sh
format-foreground = $module_foreground 
format-background = $color1

[module/powermenu_seperator]
type=custom/text
label = "%{T4}%{T-}"
format-background = $color2 
format-foreground = $color1

[module/xworkspaces]
icon-0 = 1;󰲠
icon-1 = 2;󰲢
icon-2 = 3;󰲤
icon-3 = 4;󰲦
icon-4 = 5;󰲨
icon-5 = 6;󰲪
icon-6 = 7;󰲬
icon-7 = 8;󰲮
icon-8 = 9;󰲰
icon-9 = 10;󰿬
type = internal/xworkspaces
label-active = %icon%
label-urgent = %icon%
label-visible = %icon%
label-empty = %icon%
label-occupied = %icon%

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

[module/xworkspaces_seperator]
type=custom/text
label = "%{T4}%{T-}"
format-background = $color3
format-foreground = $color2 

[module/polywins]
type = internal/xwindow
label = "%{T2}%class%%{T-}"
label-padding = 0
label-maxlen = 20 
format-prefix = " "
format = "<label>"
format-foreground = $module_foreground
format-background = $color3
label-empty = "Welcome %{T2}$USER%{T-}"
label-underline = $module_foreground

[module/left_suffix]
type=custom/text
label = "%{T4}%{T-}"
format-background = $background_transparent
format-foreground = $color3
EOM

POLYBAR_CONFIG_PATH=$(mktemp --suffix=".ini")
echo "$POLYBAR_CONFIG" > "$POLYBAR_CONFIG_PATH"
polybar -c "$POLYBAR_CONFIG_PATH" bar_main & 
