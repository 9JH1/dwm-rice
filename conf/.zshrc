wal -R -q -n -t -e
read -r -d '' FASTFETCH_CONFIG << EOF 
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "modules": [
    "title",
    "separator",
		"terminal",
		"wm",
    "cpu",
    "gpu",
    "memory",
		"colors"
  ]
}
EOF

source $HOME/.cache/wal/colors.sh 
read -r -d '' TMUX_CONFIG << EOF
set -g mouse on
set -g allow-passthrough on
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",alacritty:RGB"
set -g default-command "export ZDOTDIR=$ZDOTDIR && zsh"
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set -g bell-action none
set -g status-justify right
set -g status-position top
set -g status-left ''
set -g status-left-length 15
set -g status-right ''
set -g status-right-length 50

setw -g clock-mode-colour           'red'
set -g status-right-style           'fg=black  bg=default'
setw -g window-status-current-style 'fg=black  bg=default'
set -g pane-active-border-style     'fg=black  bg=default'
setw -g window-status-style         'fg=black  bg=default'
setw -g mode-style                  'fg=black  bg=default'
set -g pane-border-style            'fg=black  bg=default'
set -g status-style                 'fg=black  bg=default'
setw -g window-status-bell-style    'fg=black  bg=default'
set -g message-style                'fg=black  bg=default'

set -g status-interval 5
set -g status-right " #[fg=green]#[fg=black,bg=green] #[bold]#[bold]#{pane_current_command} #[fg=green,bg=default] "
set -g status-left " #[fg=blue]#[fg=black,bg=blue] #[bold]#(ps -p #{pane_pid} -o etime=)% #[fg=blue,bg=default]"
setw -g window-status-format "#[fg=black]#[fg=yellow,bg=black]#I #[fg=white,bg=black,bold]#W #[fg=yellow]#F#[fg=black]#[fg=black,bg=default]"
setw -g window-status-current-format "#[fg=red]#[fg=black,bg=red]#I #[bold]#W #F#[fg=red,bg=default]"
EOF

TMUX_PATH="/tmp/tmux.conf"
echo "$TMUX_CONFIG" > "$TMUX_PATH"

FASTFETCH_PATH=$(mktemp --suffix=".jsonc")
echo "$FASTFETCH_CONFIG" > "$FASTFETCH_PATH"

#z4h settings 
zstyle ':z4h:' auto-update      'no'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:bindkey' keyboard  'pc'
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'no'
zstyle ':z4h:direnv'         enable 'no'
zstyle ':z4h:direnv:success' notify 'yes'

if [[ "$ZSH_ISOLATE" =  "1" ]]; then
	zstyle ':z4h:' start-tmux command ""
else 
	zstyle ':z4h:' start-tmux command tmux -f "$TMUX_PATH" -u new -A -D -t zsh
fi

# define settings for greeter loading
function dwm_zsh_custom_startup_screen {
	clear
	stty -echo -icanon
	echo -e '\033[?25l'
	fastfetch --logo $(cat ~/.wallpaper) --config "$FASTFETCH_PATH" --logo-width 50
	read > /dev/tty
	echo -e '\033[?25h'
	stty sane 
}

if [ -n "$TMUX" ] && [ "$(tmux display-message -p '#{pane_index}')" = "0" ];then 
	dwm_zsh_custom_startup_screen
fi

z4h init

# custom cd functions for better navigation
export localcd=""
function cd(){
	builtin cd "$@"
	echo "$(pwd)" > ~/.pwd.tmp
}

function n(){
	nvim "$@"
}

function cds(){
	localcd="$(cat ~/.pwd.tmp)"
}
function cdd(){
	cd "$localcd"
}

# move to last cd'd dir
cds

function linecount(){
	ls -R | wc -l
}

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

function ls {
	lsd $@ --color=auto -r -t -l
}

alias clear="clear && echo"
eval "$(zoxide init zsh)"
