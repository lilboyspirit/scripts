#!/bin/bash

# update the package manager
sudo xbps-install -Suy xbps

# setup doas (Expecting 'spirit' is the user running this script)
sudo xbps-install -y opendoas
sudo bash -c "echo 'permit nopass spirit as root' > /etc/doas.conf"

# update deps to avoid conflicts
doas xbps-install -yu util-linux
# install deps required for setup
doas xbps-install -y git rsync make gcc libX11-devel libXft-devel libXinerama-devel xorg-server xinit xauth xorg-fonts xorg-input-drivers pkg-config

mkdir $HOME/repos/
cd $HOME/repos
git clone https://github.com/lilboyspirit/dotfiles.git
git clone https://github.com/lilboyspirit/dwm.git
git clone https://github.com/lilboyspirit/st.git

rsync -a --exclude='.git/' --exclude='LICENSE' dotfiles/ $HOME

cd dwm
doas make clean install

cd ../st
doas make clean install

echo 'exec dwm' > $HOME/.xinitrc

# update system
doas xbps-install -Suy
# install other packages
doas xbps-install -y wget curl yt-dl vim firefox vscode
