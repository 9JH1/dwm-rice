#!/bin/bash
isYes() {
	choice="$1"
  if [[ "$choice" =~ ^[Yy]([Ee][Ss])?$ ]]; then return 0  # Yes
	elif [[ "$choice" =~ ^[Nn]([Oo])?$ ]]; then return 1  # No
  else return 2; fi
}

remove_yay_install=1;
if ! command -v yay &> /dev/null;then
	echo "It seems you don't have yay installed";
	read -p "Should I install yay? [y/N]: " choice 
	if ! isYes "$choice";then
		echo "Cannot continue without yay"
		exit
	fi
	read -p "Remove yay after installation completed? [y/N]: " choice
	if ! isYes "$choice"; then remove_yay_install=0;
	else remove_yay_install=1; fi 
		
	# install yay 
	echo "Installing Yay, this may take some time"
	sudo pacman -S --needed git base-devel --noconfirm
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	echo "there will be a yay directory left whereever you executed this installer"
	echo "Installed Yay at $(which yay)!"
fi

# install non aur packages
echo "Installing Non AUR packages.."
echo "Installing AUR packages"
yay -Syy --noconfirm walcord i3lock-color python-pywalfox python-pywal16 picom-yaoccc-git nerdfonts-installer-bin snixembed  kitty rofi zsh tmux polybar maim xclip xwallpaper feh fastfetch zoxide plank python-i3ipc lsd xrandr ueberzug lxqt-policykit autotiling xdotool unclutter playerctl jgmenu dunst
echo "Done!"
echo "Uninstalling Yay"
if $remove_yay_install; then
	sudo pacman -Rc yay
fi

echo "Installing fonts"
nerdfonts-installer-bin | yes "48 51 69"
echo "Done!"
echo "Creating directorys and files"
mkdir ~/Pictures
mkdir ~/Pictures/Wallpapers
touch .i3dockpid 
touch .pwd.tmp 
touch .frame.jpg 
touch ~/.i3wallpaper
echo "Done!"
echo "Installation all finished!"
i3-msg reload
