isolate=0;
if [[ "$1" == "-isolate" ]]; then 
	isolate=1;
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

read -r -d '' ALACRITTY_CONFIG << EOM


[window]
decorations="None"
dynamic_title=true
dynamic_padding = true 
opacity = 0.8

[window.dimensions] 
columns = 60 
lines = 15

[window.padding]
x = 10 
y = 10

[cursor.style]
shape = "Underline"
blinking = "On"

[cursor]
blink_interval = 400 

[font]
size = 15

[font.normal]
family='Mononoki Nerd Font'
style='Bold'

[font.bold]
family='Mononoki Nerd Font'
style='Bold'

[font.italic]
family='Victor Mono Nerd Font'
style='Bold Italic'

[font.bold_italic]
family='Victor Mono Nerd Font'
style='Bold Italic'

[terminal]

[terminal.shell]
program = "/bin/sh"
args = ["-c","export ZDOTDIR=$SCRIPT_DIR/../conf/ && export ZSH_ISOLATE=$isolate && zsh"]

[general]
import = ['/tmp/alacritty-extra.toml']
EOM
#[cursor]
#smooth_motion = true
#smooth_motion_factor = 0.7
#smooth_motion_spring = 0.5
#smooth_motion_max_stretch_x = 10.0
#smooth_motion_max_stretch_y = 10.0

ALACRITTY_PATH="/tmp/alacritty.toml"
ALACRITTY_COLORS=$(cat $HOME/.cache/wal/colors-alacritty.toml)
echo "$ALACRITTY_CONFIG" > "$ALACRITTY_PATH"
echo "$ALACRITTY_COLORS" >> "$ALACRITTY_PATH"
echo running $SCRIPT_DIR/zsh.sh

if [[ "$1" == "no-run" ]]; then
	exit
fi 

if [[ "$1" == "-isolate" ]]; then 
	echo "Running isolated Term"
	alacritty --config-file "$ALACRITTY_PATH" --class "iso_term"
else 
	alacritty --config-file "$ALACRITTY_PATH"
fi
