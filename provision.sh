#!/bin/bash

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Starting provisioning."

sudo apt -y install curl

sudo apt -y purge firefox 
sudo apt -y purge firefox-esr 
sudo apt -y purge chromium 
sudo apt -y purge epiphany-browser 
sudo apt -y purge evolution 
sudo apt -y purge transmission-gtk

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'

sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

sudo apt -y install htop 
sudo apt -y install tmux 
sudo apt -y install git 
sudo apt -y install nmap 
sudo apt -y install barrier 
sudo apt -y install codium 
sudo apt -y install python3-pip 
sudo apt -y install twine 
sudo apt -y install zotero 
sudo apt -y install virtualbox 
sudo apt -y install transmission 
sudo apt -y install keepassxc 
sudo apt -y install cmatrix 
sudo apt -y install curtail 
sudo apt -y install imagemagick 
sudo apt -y install nautilus-image-converter 
sudo apt -y install microsoft-edge-stable
sudo apt -y install ttf-mscorefonts-installer

su - $SUDO_USER && mkdir ~/.fonts && curl https://raw.githubusercontent.com/justinsloan/provision/main/fonts.sh | bash

echo "Provisioning of this system is complete."

exit 0