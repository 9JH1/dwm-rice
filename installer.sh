sudo pacman -Sy git polybar rofi pipewire pipewire-pulse yajl dunst conky playerctl tmux zsh zoxide fastfetch lsd maim xclip xorg-xrandr xorg-xset --noconfirm 
git clone https://aur.archlinux.org/yay.git 
cd yay
makepkg -si 
cd ..
rm -rf yay
yay -S picom-ft-udev nerdfonts-installer-bin ueberzugpp i3lock-color --noconfirm
