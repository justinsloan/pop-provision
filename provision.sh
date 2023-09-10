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

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "==> Starting provisioning."

# Check for curl
if exists curl; then 
    echo "==> curl already installed"
else
    sudo apt -y install curl
fi

# Purge/Remove Unneeded Default Packages
sudo apt -y purge firefox 
sudo apt -y purge chromium 
sudo apt -y purge evolution 
sudo apt -y purge epiphany-browser

# Install Additional Repositories
## Microsoft Edge (Yes, I actually like this browser)
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm microsoft.gpg

## Microsoft Debian Bulls Eye
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

## VS Codium
curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'
rm -f vscodium.gpg

## OneDriver
### Client for Microsoft OneDrive
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null

## Librewolf
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates
distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

# Update the System
sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

# Install Packages
sudo apt -y install librewolf
sudo apt -y install gnupg 
sudo apt -y install gthumb
sudo apt -y install gdu
sudo apt -y install iperf3
sudo apt -y install apt-transport-https
sudo apt -y install cabextract
sudo apt -y install htop 
sudo apt -y install ncdu
sudo apt -y install tmux 
sudo apt -y install git 
sudo apt -y install nmap
sudo apt -y install foliate
sudo apt -y install codium 
sudo apt -y install python3-pip 
sudo apt -y install twine 
sudo apt -y install remmina
sudo apt -y install inetutils-traceroute
sudo apt -y install traceroute
sudo apt -y install torbrowser-launcher
sudo apt -y install cmatrix 
sudo apt -y install neofetch
sudo apt -y install curtail 
sudo apt -y install imagemagick 
sudo apt -y install nautilus-image-converter
sudo apt -y install gnome-tweaks 
sudo apt -y install microsoft-edge-stable
sudo apt -y install powershell
sudo apt -y install onedriver
sudo apt -y install heif-gdk-pixbuf
sudo apt -y install gnome-sushi
sudo apt -y install epiphany-browser
sudo apt -y install flameshot
sudo apt -y install autokey-gtk
sudp apt -y install glances
sudo apt -y install fzf
sudo apt -y install virtualbox
sudo apt -y install virtualbox-guest-additions-iso

## Install SSH server
sudo apt -y install openssh-server
### SSH is enabled by default, so let's stop it
sudo systemctl stop ssh

# Install 1Password
curl https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb --output 1password.deb
sudo dpkg -i ./1password.deb

# Install Python Packages
pip3 install quantumdiceware
pip3 install pyoath
pip3 install pyotp

# Install Codium Extensions
sudo -u $SUDO_USER codium - --install-extension sleistner.vscode-fileutils
sudo -u $SUDO_USER codium - --install-extension streetsidesoftware.code-spell-checker
sudo -u $SUDO_USER codium - --install-extension ms-python.python
sudo -u $SUDO_USER codium - --install-extension janisdd.vscode-edit-csv
sudo -u $SUDO_USER codium - --install-extension ms-vscode.powershell

# Install Microsoft Fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts 
sudo -u $SUDO_USER curl https://raw.githubusercontent.com/justinsloan/pop-provision/main/fonts.sh | sudo -u $SUDO_USER bash
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb -P ~/Downloads
sudo apt -y install ~/Downloads/ttf-mscorefonts-installer_3.6_all.deb
rm ~/Downloads/ttf-mscorefonts-installer_3.6_all.deb

# Add user Home to PATH
PATHA='export PATH=$PATH'
PATHB="/home/$SUDO_USER/.local/bin"
echo " " >> /home/$SUDO_USER/.bashrc
echo "$PATHA:$PATHB" >> /home/$SUDO_USER/.bashrc

# Create some handy bash aliases
echo "alias myip='curl checkip.amazonaws.com'" >> /home/$SUDO_USER/.bash_aliases
echo "alias update='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'" >> /home/$SUDO_USER/.bash_aliases
echo "alias whichupdates='sudo apt update && apt list --upgradeable'" >> /home/$SUDO_USER/.bash_aliases
echo "alias calc='bc -l'" >> /home/$SUDO_USER/.bash_aliases
echo "alias size='pwd && find ./ -type f -exec du -Sh {} + | sort -rh | head -n 15'" >> /home/$SUDO_USER/.bash_aliases
echo "alias storage='ncdu'" >> /home/$SUDO_USER/.bash_aliases
echo "alias untar='tar -zxvf '" >> /home/$SUDO_USER/.bash_aliases
echo "alias ports='sudo netstat -tulanp'" >> /home/$SUDO_USER/.bash_aliases
echo "alias clearall='clear && history -c && history -w'" >> /home/$SUDO_USER/.bash_aliases
echo "alias gs='git pull && git push'" >> /home/$SUDO_USER/.bash_aliases
echo "alias ..='cd ..'" >> /home/$SUDO_USER/.bash_aliases
echo "alias ~='cd ~/'" >> /home/$SUDO_USER/.bash_aliases
echo "alias flush-dns='resolvectl flush-caches'" >> /home/$SUDO_USER/.bash_aliases
echo "alias fstop='ps aux | fzf'" >> /home/$SUDO_USER/.bash_aliases

# Reload the .bashrc file
source /home/$SUDO_USER/.bashrc

echo "==> Provisioning of this system is complete."

exit 0
