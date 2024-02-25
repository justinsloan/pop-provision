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

# Install Additional Repositories
## Microsoft Edge (I keep this here because I use Edge for work))
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
# rm microsoft.gpg

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

## Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Fetch updates
sudo apt update 

# Purge/Remove Unneeded Default Packages
sudo apt purge -y firefox 
sudo apt purge -y chromium 
sudo apt purge -y evolution 
sudo apt purge -y epiphany-browser

# Install the Nala apt manager
sudo apt install -y nala

# Install pending updates
sudo nala upgrade -y
sudo nala autoremove -y

# Install base pakages
sudo nala install -y brave-browser
sudo nala install -y gnupg 
sudo nala install -y gthumb
sudo nala install -y gdu
sudo nala install -y iperf3
sudo nala install -y apt-transport-https
sudo nala install -y cabextract
sudo nala install -y htop 
sudo nala install -y ncdu
sudo nala install -y tmux 
sudo nala install -y nmap
sudo nala install -y foliate
sudo nala install -y codium 
sudo nala install -y python3-pip 
sudo nala install -y twine 
sudo nala install -y remmina
sudo nala install -y inetutils-traceroute
sudo nala install -y traceroute
sudo nala install -y cmatrix 
sudo nala install -y neofetch
sudo nala install -y figlet
sudo nala install -y linuxlogo
sudo nala install -y cowsay
sudo nala install -y taskwarrior
sudo nala install -y curtail 
sudo nala install -y imagemagick 
sudo nala install -y nautilus-image-converter
sudo nala install -y gnome-tweaks 
sudo nala install -y powershell
sudo nala install -y onedriver
sudo nala install -y heif-gdk-pixbuf
sudo nala install -y gnome-sushi
sudo nala install -y flameshot
sudo nala install -y autokey-gtk
sudo nala install -y glances
sudo nala install -y fzf
sudo nala install -y virtualbox
sudo nala install -y virtualbox-guest-additions-iso
sudo nala install -y system76-keyboard-configurator

## Install SSH server
sudo nala install -y openssh-server
### SSH is enabled by default, so let's stop it
sudo systemctl stop ssh

# Install Git and set options
sudo nala install -y git 
git config --global user.name  $SUDO_USER
git config --global user.email "my@private.email"

# Install 1Password
#curl https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb --output 1password.deb
#sudo dpkg -i ./1password.deb

# Install Python Packages
sudo -u $SUDO_USER pip3 install quantumdiceware
sudo -u $SUDO_USER pip3 install pyoath
sudo -u $SUDO_USER pip3 install pyotp

# Make `xdg-open` open up directories in nemo instead of nautilus
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
# Make Gnome-controlled directories and **icons on the desktop** open up in nemo
# now instead of in nautilus
gsettings set org.gnome.shell.extensions.ding use-nemo true

# Install a configuration tool we will use below
sudo apt install dconf-editor 

# Install Codium Extensions
sudo -u $SUDO_USER codium - --install-extension sleistner.vscode-fileutils
sudo -u $SUDO_USER codium - --install-extension streetsidesoftware.code-spell-checker
sudo -u $SUDO_USER codium - --install-extension ms-python.python
#sudo -u $SUDO_USER codium - --install-extension janisdd.vscode-edit-csv
sudo -u $SUDO_USER codium - --install-extension ms-vscode.powershell
sudo -u $SUDO_USER codium - --install-extension pajoma.vscode-journal
sudo -u $SUDO_USER codium - --install-extension mads-hartmann.bash-ide-vscode
sudo -u $SUDO_USER codium - --install-extension timonwong.shellcheck
sudo -u $SUDO_USER codium - --install-extension GrapeCity.gc-excelviewer

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
echo "alias myip='curl --silent checkip.amazonaws.com | figlet'" >> /home/$SUDO_USER/.bash_aliases
echo "alias mycity='curl --silent ipinfo.io/city | figlet'" >> /home/$SUDO_USER/.bash_aliases
echo "alias myregion='curl --silent ipinfo.io/region | figlet'" >> /home/$SUDO_USER/.bash_aliases
echo "alias myisp='curl --silent ipinfo.io/org'" >> /home/$SUDO_USER/.bash_aliases
echo "alias update='sudo nala update && sudo nala upgrade -y && sudo nala autoremove -y'" >> /home/$SUDO_USER/.bash_aliases
echo "alias whichupdates='sudo nala update && nala list --upgradeable'" >> /home/$SUDO_USER/.bash_aliases
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
echo "alias showdns='resolvectl status | grep '\''DNS Server'\'' -A2'" >> /home/$SUDO_USER/.bash_aliases
echo "alias fstop='ps aux | fzf'" >> /home/$SUDO_USER/.bash_aliases
echo "alias showtime='date +%T | figlet'" >> /home/$SUDO_USER/.bash_aliases

# Reload the .bashrc file
source /home/$SUDO_USER/.bashrc

echo "==> Provisioning of this system is complete."

exit 0
