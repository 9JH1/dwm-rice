isolate=0;
if [[ "$1" == "-isolate" ]]; then 
	isolate=1;
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

read -r -d '' ALACRITTY_CONFIG << EOM
[general]
import = ['/tmp/alacritty-extra.toml']

[window]
decorations="full"
dynamic_title=true

[font]
size = 20

[font.normal]
family='Mononoki Nerd Font'
style="bold"

[font.bold]
family='MonaspiceRN NFM'
style="bold"

[font.italic]
family='Victor Mono Nerd Font'
style='Bold Italic'

[terminal]

[terminal.shell]
program = "/bin/sh"
args = ["-c", "export ZSH_ISOLATE=$isolate && $SCRIPT_DIR/zsh.sh"]

[cursor]
smooth_motion = true
smooth_motion_factor = 0.7
smooth_motion_spring = 0.5
smooth_motion_max_stretch_x = 10.0
smooth_motion_max_stretch_y = 10.0
EOM

ALACRITTY_PATH="/tmp/alacritty.toml"
ALACRITTY_COLORS=$(cat $HOME/.cache/wal/colors-alacritty.toml)
echo "$ALACRITTY_CONFIG" > "$ALACRITTY_PATH"
echo "$ALACRITTY_COLORS" >> "$ALACRITTY_PATH"

if [[ "$1" == "no-run" ]]; then
	exit
fi 

if [[ "$1" == "-isolate" ]]; then 
	echo "Running isolated Term"
	alacritty --config-file "$ALACRITTY_PATH" --class "iso_term"
else 
	alacritty --config-file "$ALACRITTY_PATH"
fi
