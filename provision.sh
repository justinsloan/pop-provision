#!/bin/bash
# +------------------------------------------------------------------------+
# | This provisioning script is specifically designed to work with BASH    |
# | under Pop!_OS by System76, although it may work equally well under any |
# | Debian-based dristribution.                                            |
# +------------------------------------------------------------------------+
# | This is free and unencumbered software released into the public domain.|
# |                                                                        |
# | Anyone is free to copy, modify, publish, use, compile, sell, or        |
# | distribute this software, either in source code form or as a compiled  |
# | binary, for any purpose, commercial or non-commercial, and by any      |
# | means.                                                                 |
# |                                                                        |
# | In jurisdictions that recognize copyright laws, the author or authors  |
# | of this software dedicate any and all copyright interest in the        |
# | software to the public domain. We make this dedication for the benefit |
# | of the public at large and to the detriment of our heirs and           |
# | successors. We intend this dedication to be an overt act of            |
# | relinquishment in perpetuity of all present and future rights to this  |
# | software under copyright law.                                          |
# |                                                                        |
# | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        |
# | EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     |
# | MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. |
# | IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR      |
# | OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,  |
# | ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR  |
# | OTHER DEALINGS IN THE SOFTWARE.                                        |
# +------------------------------------------------------------------------+

# TODO: choose custom packages config or unattended
# TODO: allow the user to specify which text file to use

$HOSTNAME=$(uname -n)

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 0
fi

# +------------------------------------------------------------------------+
# FUNCTIONS
# +------------------------------------------------------------------------+
installPackage() {
    if ! dpkg -l | grep -q $1; then
        sudo nala install -y $1
        clear
    else
        echo "$1 already installed"
    fi
}

purgePackage() {
    if dpkg -l | grep -q $1; then
        sudo apt purge -y $1
        clear
    else
        echo "$1 not installed"
    fi
}

installPythonPackage() {
    sudo -u $SUDO_USER pip3 install $1
    clear
}

# +------------------------------------------------------------------------+

echo "==> Starting provisioning for $HOSTNAME."

# Install dependencies
sudo apt update
sudo apt install -y curl nala dconf-editor

clear

# Check for local purge, install and alias lists, if not found pull 
# standard lists from repository
if [ ! -f purge_packages.txt ]; then
    curl -o purge_packages.txt https://raw.githubusercontent.com/justinsloan/pop-provision/main/purge_packages.txt
fi

if [ ! -f install_packages.txt ]; then
    curl -o install_packages.txt https://raw.githubusercontent.com/justinsloan/pop-provision/main/install_packages.txt
fi

if [ ! -f python_packages.txt ]; then
    curl -o python_packages.txt https://raw.githubusercontent.com/justinsloan/pop-provision/main/python_packages.txt
fi

if [ ! -f aliases.sh ]; then
    curl -o codium_extensions.txt https://raw.githubusercontent.com/justinsloan/pop-provision/main/aliases.sh
fi

# Fetch the fastest mirror repo
sudo nala fetch

# Install Additional Repositories
## Microsoft Edge (I keep this here because I use Edge for work))
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
# rm microsoft.gpg

## Microsoft Debian Bulls Eye
#curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

## Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Fetch updates
sudo nala update 

# Purge/Remove Unneeded Default Packages
# for each line in the text file, purge the package
while IFS= read -r line
do
    purgePackage $line
done < purge_packages.txt

# Install pending updates & clean up
sudo nala upgrade -y
sudo nala autoremove -y

# Install base pakages
# for each line in the text file, install the package
while IFS= read -r line
do
    installPackage $line
done < install_packages.txt

## Install SSH server
installPackage "openssh-server"
### SSH is enabled by default, so let's stop it
sudo systemctl stop ssh

# Install Git and set options
installPackage "git" 
git config --global user.name  $SUDO_USER
git config --global user.email "my@private.email"

# Install Python pakages
# for each line in the text file, install the package
while IFS= read -r line
do
    installPythonPackage $line
done < python_packages.txt

# Install the Micro editor
curl https://getmic.ro | sh
sudo mv micro /usr/bin

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh
echo 'Environment="HSA_OVERRIDE_GFX_VERSION=11.0.0"' | sudo tee /etc/systemd/system/ollama.service.d/override.conf
sudo systemctl daemon-reload

# Install Microsoft Fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts 
sudo -u $SUDO_USER curl https://raw.githubusercontent.com/justinsloan/pop-provision/main/fonts.sh | sudo -u $SUDO_USER bash
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb -P ~/Downloads
sudo nala -y install ~/Downloads/ttf-mscorefonts-installer_3.8.1_all.deb
rm ~/Downloads/ttf-mscorefonts-installer_3.8.1_all.deb

# Add user Home to PATH
PATHA='export PATH=$PATH'
PATHB="/home/$SUDO_USER/.local/bin"
echo " " >> /home/$SUDO_USER/.bashrc
echo "$PATHA:$PATHB" >> /home/$SUDO_USER/.bashrc

# Create some handy bash aliases
sudo chmod +x ./aliases.sh
source ./aliases.sh

# Reload the .bashrc file
source /home/$SUDO_USER/.bashrc
clear

# Setup Yubikey authentication
#sudo -u $SUDO_USER curl https://raw.githubusercontent.com/justinsloan/pop-provision/main/yubikey.sh | sudo -u $SUDO_USER bash

# Create a certificate for Barrier
mkdir -p /home/$SUDO_USER/.local/share/barrier/SSL/
openssl req -x509 -nodes -days 365 -subj /CN=Barrier -newkey rsa:2048 -keyout /home/$SUDO_USER/.local/share/barrier/SSL/Barrier.pem -out /home/$SUDO_USER/.local/share/barrier/SSL/Barrier.pem

# Update the Pop_OS! recovery partition
pop-upgrade recovery upgrade from-release

clear

echo "==> Provisioning of $HOSTNAME is complete."

exit 0
