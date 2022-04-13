#!/bin/bash

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Starting provisioning."

sudo apt purge firefox firefox-esr chromium epiphany-browser evolution transmission-gtk

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'

sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

sudo apt -y install cabextract 
sudo apt -y install htop 
sudo apt -y install tmux 
sudo apt -y install git nmap barrier codium python3-pip twine zotero virtualbox transmission keepassxc cmatrix curtail imagemagick nautilus-image-converter ttf-mscorefonts-installer microsoft-edge-stable

echo "Provisioning of this system is complete."

exit 0