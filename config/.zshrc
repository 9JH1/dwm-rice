read -r -d '' FASTFETCH_CONFIG << EOF 
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "modules": []
}
EOF

# set -g default-terminal "tmux-256color"
# set -ag terminal-overrides ",alacritty:RGB"

# source $HOME/.cache/wal/colors.sh 
wal -w -t -e -s

read -r -d '' TMUX_CONFIG << EOF
set -g mouse on
set -g allow-passthrough on

set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",st:RGB"
set -g default-command "export ZDOTDIR=$ZDOTDIR && zsh"
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set-option -g status-justify centre
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


FASTFETCH_PATH=$(mktemp --suffix=".jsonc")
echo "$FASTFETCH_CONFIG" > "$FASTFETCH_PATH"

if [ -n "$TMUX" ] && [ "$(tmux display-message -p '#{pane_index}')" = "0" ];then 
	dwm_zsh_custom_startup_screen
elif [[ ! "$ZSH_ISOLATE" =  "1" ]]; then
	tmux -f "$TMUX_PATH" -u new -A -D
fi

# define settings for greeter loading
function dwm_zsh_custom_startup_screen {
	clear
	stty -echo -icanon
	echo -e '\033[?25l'
	fastfetch --logo "$(cat ~/.wallpaper)" --config "$FASTFETCH_PATH" --logo-width 50
	read > /dev/tty
	echo -e '\033[?25h'
	stty sane 
}


# custom cd functions for better navigation
export localcd=""
function cd(){
	builtin cd "$@"
	echo "$(pwd)" > ~/.pwd.tmp
}

function n(){
	nvim "$@"
}


function cdd(){
	cd "$localcd"
}

localcd="$(cat ~/.pwd.tmp)"
function true-colors(){
awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
}'

}
function cdr() {
	dirs=(*/)
	[[ $dirs ]] && cd -- "${dirs[RANDOM%${#dirs[@]}]}"
}

# Define aliases.
alias tree='tree -a -I .git'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pacman='pacman --color=auto'
alias yay='yay --color=auto'
alias sudo='sudo '

function ls {
	lsd $@ --color=auto -r -t -l
}

eval "$(zoxide init zsh)"
