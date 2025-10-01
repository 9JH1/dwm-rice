function install_dwm_rice {

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
	yay -S --needed picom-ft-udev ueberzugpp i3lock-color python-pywal16 pywalfox walcord picom --noconfirm

	echo "applying fonts"
	mkdir ~/.fonts 
	cp -r fonts ~/.fonts
	fc-cache -fv
	
	echo "installing motionlayer"
	git clone https://github.com/9jh1/C
	cd C/motionlayer/src
	./comp 
	sudo mv motionlayer /usr/bin/motionlayer
}

echo "Installing dwm rice"
time install_dwm_rice
echo "Done"
