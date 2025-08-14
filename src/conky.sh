#!/bin/bash 

source ~/.cache/wal/colors.sh

read -r -d '' CONKY_CONF << EOF 
conky.config = {
    alignment = 'bottom_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = '$color7',
    default_outline_color = 'white',
    default_shade_color = '$color0',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = true,
    extra_newline = false,
    gap_x = 10,

		-- 50 is the bottom gap width plus the padding of 5 px
    gap_y = 55,
    own_window_transparent = true,
		minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_wayland = false,
    out_to_x = true,
    own_window = true,
		own_window_type = 'override',
    own_window_class = 'Conky',
    own_window_hints = 'undecorated,sticky,below,skip_taskbar,skip_pager',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

-- Variables: https://conky.cc/variables
conky.text = [[
\${alignr}\${voffset 65}\${font Mononoki Nerd Font:size=70:weight=light}\${exec date +%I:%M}
\${alignr}\${voffset -45}\${font Mononoki Nerd Font:size=40:style=italic}\${exec date +%A' '%d}

]]
EOF

CONFIG_PATH="/tmp/conky.conf"
echo "$CONKY_CONF" > "$CONFIG_PATH"

killall conky 
conky -c "$CONFIG_PATH"
