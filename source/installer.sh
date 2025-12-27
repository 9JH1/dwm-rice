function install_dwm_rice {
	echo "moving files"
	mv ../dwm-rice ~/.dwm &>/dev/null
	cd ~/.dwm

	echo "installing non aur packages"
	sudo pacman -Sy --needed jq git unzip git polybar rofi pipewire pipewire-pulse yajl dunst conky playerctl tmux zsh zoxide fastfetch lsd maim xclip xorg-xrandr xorg-xset xwallpaper feh alacritty dunst --noconfirm 

	if ! command -v yay &>/dev/null; then
		echo "installing yay"
		git clone https://aur.archlinux.org/yay.git 
		cd yay
		makepkg -si 
		cd ..
		rm -rf yay
	fi 

	echo "installing aur packages"
	yay -S --needed picom ueberzugpp i3lock-color python-pywal16 walcord picom --noconfirm

	
	echo "installing motionlayer"
	git clone https://github.com/9jh1/C
	cd C/motionlayer/src
	./comp 
	sudo mv motionlayer /usr/bin/motionlayer
	
	echo "installing oomox (gtk themeing)"
	cd ~/.themes 
	git clone https://github.com/themix-project/oomox-gtk-theme
	cd -

	echo "installing simpleanalogclockfont"
	git clone https://github.com/fshaxe/SimpleAnalogClockFont 
	mkdir -p ~/.local/share/fonts
	cp SimpleAnalogClockFont/*.ttf ~/.local/share/fonts/
	fc-cache -f -v
	rm -rf SimpleAnalogClockFont
	
	echo "applying fonts"
	mkdir ~/.fonts 
	cp -r fonts ~/.fonts
	fc-cache -fv ~/.fonts

	echo "updating config" 
	sed -i "s/_3hy/$USER/g" ./config.def.h
}

echo "Installing.."
time install_dwm_rice
echo "Done"
