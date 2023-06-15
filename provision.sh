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

# Install Additional Repositories
## Microsoft Edge
### I am keeping this repository available just in case it is needed since I use Linux at work
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
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null


# Update the System
sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

# Install Packages
sudo apt -y install gnupg 
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
#sudo apt -y install microsoft-edge-stable
sudo apt -y install powershell
sudo apt -y install onedriver
sudo apt -y install heif-gdk-pixbuf
sudo apt -y install gnome-sushi
sudo apt -y install epiphany-browser

# Install Python Packages
pip3 install quantumdiceware
pip3 install pyoath

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

# Reload the .bashrc file
source /home/$SUDO_USER/.bashrc

echo "==> Provisioning of this system is complete."

exit 0
