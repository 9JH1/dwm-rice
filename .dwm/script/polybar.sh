#!/bin/bash 
# Runs polybar (old)
#

if [ "$1" = "--toggle" ];then 
	if [ -n "$(pgrep 'polybar')" ];then 
		echo "polybar is running. killing.."
		killall polybar 
		exit
	fi 
	echo "polybar not running. starting.." 
fi

# Imports and declarations
source ~/.cache/wal/colors.sh
saturate_hex() {
    local hex="$1" s="$2" b="$3" h="$4"
    hex="${hex#\#}"
    [[ "$hex" =~ ^[0-9A-Fa-f]{6}$ ]] || { echo "error: bad hex" >&2; return 1; }

    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local bb=$((16#${hex:4:2}))  # avoid conflict with var 'b'

    # === NEW: treat 0.0 as "no change" (1.0) ===
    (( $(awk "BEGIN{print ($s == 0)}") )) && s=1.0
    (( $(awk "BEGIN{print ($b == 0)}") )) && b=1.0

    local newhex
    newhex=$(awk -v r="$r" -v g="$g" -v b="$bb" \
                 -v s_mul="$s" -v b_mul="$b" -v h_add="$h" '
    function myabs(x) { return x < 0 ? -x : x }

    BEGIN {
        R = r/255; G = g/255; B = b/255;

        Cmax = (R > G ? (R > B ? R : B) : (G > B ? G : B));
        Cmin = (R < G ? (R < B ? R : B) : (G < B ? G : B));
        delta = Cmax - Cmin;

        # Hue
        if (delta == 0) H = 0;
        else if (Cmax == R) H = 60 * ((G-B)/delta) + (G < B ? 360 : 0);
        else if (Cmax == G) H = 60 * ((B-R)/delta + 2);
        else H = 60 * ((R-G)/delta + 4);

        # Lightness
        L = (Cmax + Cmin)/2;

        # Saturation
        if (delta == 0) S = 0;
        else S = delta / (1 - myabs(2*L - 1));

        # Apply modifiers
        S *= s_mul;
        if (S > 1) S = 1;
        L *= b_mul;
        if (L > 1) L = 1; if (L < 0) L = 0;
        H = (H + h_add) % 360;

        # HSL → RGB
        if (S == 0) {
            R = G = B = L;
        } else {
            C = (1 - myabs(2*L - 1)) * S;
            X = C * (1 - myabs(int(H/60) % 2 - 1));
            m = L - C/2;

            h60 = int(H/60);
            if (h60 == 0) { Rp=C; Gp=X; Bp=0; }
            else if (h60 == 1) { Rp=X; Gp=C; Bp=0; }
            else if (h60 == 2) { Rp=0; Gp=C; Bp=X; }
            else if (h60 == 3) { Rp=0; Gp=X; Bp=C; }
            else if (h60 == 4) { Rp=X; Gp=0; Bp=C; }
            else { Rp=C; Gp=0; Bp=X; }

            R = Rp + m; G = Gp + m; B = Bp + m;
        }

        r = int(R*255 + 0.5);
        g = int(G*255 + 0.5);
        b = int(B*255 + 0.5);

        printf "#%02X%02X%02X\n", r, g, b;
    }')
    printf '%s\n' "$newhex"
}

# Opacity
opacity=70 
opacity=$(((opacity * 255) / 100))
background_transparent="#"$(printf "%X" "$opacity")"${background:1}"

# Basic Colors
border_color=$color0
foreground=$foreground
accent_color=$color6
foreground_dim=$color6

# Advanced Settings
padding="2"
polybar_height=30;
polybar_border_size=3;
accent_icon_sat=0
accent_icon_dim=0
accent_icon_hue=0
tray_icon_scale="80%"
dpi=100

# Fonts
regular_font="Terminus:size=20;3.5" 
bold_font="Terminus:style=Bold:size=20;3.5"
icon_font="Mononoki Nerd Font:style=Regular:size=15;3.2"

# Post Values
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ac0=$(saturate_hex "$color2" $accent_icon_sat $accent_icon_dim $accent_icon_hue)
ac1=$(saturate_hex "$color6" $accent_icon_sat $accent_icon_dim $accent_icon_hue)
ac2=$(saturate_hex "$color4" $accent_icon_sat $accent_icon_dim $accent_icon_hue)
ac3=$(saturate_hex "$color5" $accent_icon_sat $accent_icon_dim $accent_icon_hue)
foreground_dim=$(saturate_hex "$foreground_dim" 1.0 1.5 0)
accent_color=$(saturate_hex "$accent_color" 1.0 1.0 0)

read -r -d '' POLYBAR_FONT_CONFIG << EOM
font-2 = $icon_font 
font-1 = $bold_font 
font-0 = $regular_font
dpi = $dpi
height = $(echo "$polybar_height")px
border-size = $(echo "$polybar_border_size")px
border-color = $background
width = $((1920-20))px
offset-x = 10px
offset-y = 10px

line-size = 2
background = $background_transparent
module-margin = 1
foreground = $foreground
fixed-center = true
padding = $padding
enable-ipc=true
EOM


read -r -d '' POLYBAR_CONFIG << EOM
[bar/bar_main]
modules-left = powermenu s cpu s ram s load 
modules-right = systray s notify s xkeyboard s date
modules-center = xworkspaces
$POLYBAR_FONT_CONFIG

[bar/bar_dock]
bottom =  true 
modules-left = playerctl_prev playerctl_ipc playerctl_next playerctl
modules-right = network s audio s filesystem s xwindow s xmonitor
$POLYBAR_FONT_CONFIG

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock
blacklist-1 = caps lock


label-layout = %layout%-%variant%

[module/network]
type = internal/network
interface = enp5s0
label-connected = "%{T3}%{F$ac0}󰤨 %{T- F-} %downspeed%"
interval = 5
format-connected = "<label-connected>"

[module/filesystem]
type = internal/fs
mount-0 = /
interval = 10
fixed-values = true
spacing = $((padding * 2))
warn-percentage = 75
label-mounted = %free%
format-mounted = "%{F$ac3}%{T3} %{F- T-} <label-mounted>"

[module/notify]
type=custom/ipc 
hook-0 = echo "%{T3}%{F$ac3}\$($SCRIPT_DIR/notify.sh)%{T- F-}"
initial = 1 
format = <output>
click-left = "dunstctl set-paused toggle && polybar-msg action notify hook 0"

[module/s]
type=custom/text 
label= "|"
format = <label>
format-foreground = $accent_color

[module/ram]
type=internal/memory
interval=5
warn-percentage=95 
label = %percentage_used%%
label-warn = !%free% left
format = "%{T3}%{F$ac1}  %{F-}%{T-}<label>"

[module/cpu]
interval=5
type=custom/script 
exec = "$SCRIPT_DIR/cpu.sh"
tail = true
format = "%{T3}%{F$ac0}  %{F-}%{T-}<label>"

[module/playerctl_ipc]
type = custom/ipc
hook-0 = "$SCRIPT_DIR/playerctl_icon.sh"
initial = 1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null
click-middle = playerctl previous
format ="%{F$foreground_dim}%{T3}<output>%{T- F-}"

[module/playerctl]
type=custom/script
exec = "$SCRIPT_DIR/playerctl.sh" && polybar-msg action playerctl_ipc hook 0 > /dev/null
format ="%{F$ac0}<label>%{F-}"
interval=1
click-left = playerctl play-pause && polybar-msg action playerctl_ipc hook 0 > /dev/null

[module/audio]
type = internal/pulseaudio
label-volume = %percentage%%
label-muted = 󰖁
ramp-volume-0 = 󰕿
ramp-volume-1 = 󰖀
ramp-volume-2 = 󰕾
format-volume = "%{T3}%{F$ac0}<ramp-volume>%{T- F-} <label-volume>"
format-muted = "%{T3}%{F$ac0}<label-muted>%{T- F-} 0%"

[module/load]
type = custom/script 
exec = "$SCRIPT_DIR/load.sh"
interval = 5
label = %output%
format = "%{F$ac0}%{T3} %{F- T-} <label>"

[module/systray]
type = internal/tray
tray-spacing = 4pt
tray-size = $tray_icon_scale
tray-foreground = $module_foreground

[module/date]
type = internal/date
interval = 60
date = "%{F$foreground_dim}%{T2}%I:%M%{T- F-}"
date-alt = "%{F$foreground_dim}%{T2}%d/%m/%Y%{T- F-}"

[module/playerctl_next]
type=custom/text 
label = 󰒭
click-left = playerctl next && polybar-msg action playerctl hook 0 > /dev/null
format = "%{F$foreground_dim}%{T3}<label>%{T- F-}"

[module/playerctl_prev]
type = custom/text 
label = 󰒮
click-left = playerctl previous && polybar-msg action playerctl hook 0 > /dev/null
format = "%{F$foreground_dim}%{T3}<label>%{T- F-}"

[module/powermenu]
type = custom/script
exec = ~/.dwm/src/symbol.sh
format = %{F$foreground_dim}%{T2}<label>%{T- F-}
tail = true

[module/xworkspaces]
type = custom/script
exec = $SCRIPT_DIR/workspace.sh
tail = true
label = %output%
format = <label>

[module/xwindow]
type = internal/xwindow
label-padding = 0
label-maxlen = 100
label = %instance%
format= "%{T3}%{F$ac3}󱂬 %{F- T-}<label>"

label-empty = "Desktop"
format-empty = "%{T3}%{F$ac3}󱂬 %{F- T-}<label-empty>"

[module/xmonitor]
type = custom/script 
exec = $SCRIPT_DIR/monitor.sh 
tail = true 
label = %output%
format = "%{F$foreground_dim}%{T2}<label>%{T- F-}"
EOM

POLYBAR_CONFIG_PATH="$HOME/.cache/polybar.ini"

if [ ! -f "$POLYBAR_CONFIG_PATH" ];then  
	touch "$POLYBAR_CONFIG_PATH"
fi


echo "$POLYBAR_CONFIG" > "$POLYBAR_CONFIG_PATH"
if [[ "$1" == "no-run" ]]; then 
	exit 
fi



pkill -TERM polybar

polybar -c "$POLYBAR_CONFIG_PATH" bar_main & 
polybar -c "$POLYBAR_CONFIG_PATH" bar_dock &

pid=$!
while [ 1 ];do
	ps -p $pid > /dev/null 
	if [ $? -eq 0 ];then 
	 polybar-msg action playerctl hook 0 &>/dev/null
	 sleep 1
 else 
	 echo "Exiting polybar script"
	 exit 
	fi
done 
