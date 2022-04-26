#!/bin/bash

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
sudo apt -y purge epiphany-browser 
sudo apt -y purge evolution 
sudo apt -y purge transmission-gtk

# Install Additional Repositories
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm microsoft.gpg

curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'
rm vscodium.gpg

# Update the System
sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

# Install Packages
sudo apt -y install cabextract
sudo apt -y install htop 
sudo apt -y install ncdu
sudo apt -y install tmux 
sudo apt -y install git 
sudo apt -y install nmap 
sudo apt -y install barrier 
sudo apt -y install codium 
sudo apt -y install python3-pip 
sudo apt -y install twine 
sudo apt -y install zotero 
sudo apt -y install remmina
sudo apt -y install inetutils-traceroute
sudo apt -y install traceroute
sudo apt -y install transmission
sudo apt -y install keepassxc 
sudo apt -y install torbrowser-launcher
sudo apt -y install cmatrix 
sudo apt -y install neofetch
sudo apt -y install curtail 
sudo apt -y install imagemagick 
sudo apt -y install nautilus-image-converter
sudo apt -y install gnome-tweaks 
sudo apt -y install microsoft-edge-stable

# Install Python Packages
pip3 install quantumdiceware

# Install Codium Extensions
sudo -u $SUDO_USER codium - --install-extension sleistner.vscode-fileutils
sudo -u $SUDO_USER codium - --install-extension streetsidesoftware.code-spell-checker
sudo -u $SUDO_USER codium - --install-extension ms-python.python

# Install Microsoft Fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts 
sudo -u $SUDO_USER curl https://raw.githubusercontent.com/justinsloan/provision/main/fonts.sh | sudo -u $SUDO_USER bash
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
