#
# ~/.bashrc
#



# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ ! -n $BASH_START_FLAG ]] && return


alias grep='grep --color=auto'
PS1='\e[30;42;3m\w \\$\e[0m '

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

function ls(){
	lsd --icon=never
}

# Tmux config
TMUX_PATH="/tmp/tmux.conf"
read -r -d '' TMUX_CONFIG << EOF
set -g mouse on
set -g allow-passthrough on
set -g default-command "bash"

set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",st:RGB"
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set-option -g status-justify right
set -g bell-action none
set -g status-justify right
set -g status-position top
set -g status-left ''
set -g status-left-length 15
set -g status-right ''
set -g status-right-length 50
set -g default-command "${SHELL}"
unbind-key -n C-Left
unbind-key -n C-Right  
unbind-key -n C-Up
unbind-key -n C-Down
bind-key h select-pane -L # move left
bind-key j select-pane -D # move down
bind-key k select-pane -U # move up
bind-key l select-pane -R # move right
set -g focus-events on
set -g status-style bg=default
set -g status-left-length 99
set -g status-right-length 99
set -g status-justify absolute-centre
EOF

TMUX_PATH="/tmp/tmux.conf"
echo "$TMUX_CONFIG" > "$TMUX_PATH"
tmux source-file "$TMUX_PATH"

if [ -n "$TMUX" ];then 
	source -- ~/.local/share/blesh/ble.sh	
	source ~/.cache/wal/colors.sh
	
	if [ "$(tmux display-message -p '#{pane_index}')" = "0" ];then 
		# Run on startup of first pane
		hyfetch
	fi

elif [[ ! "$ZSH_ISOLATE" =  "1" ]]; then
	tmux -f "$TMUX_PATH" -u new -A -D
	exit
fi

