#!/bin/bash

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo apt --purge remove firefox firefox-esr chromium epiphany evolution

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'

sudo apt update 
sudo apt -y upgrade
sudo apt -y autoremove

sudo apt -y install htop tmux git nmap barrier codium python3-pip twine zotero virtualbox transmission keepassxc cmatrix curtail imagemagick nautilus-image-converter ttf-mscorefonts-installer microsoft-edge-stable

# Install Microsoft Fonts
mkdir ~/.fonts

set -e

die() { exec 2>&1 ; for line ; do echo "$line" ; done ; exit 1 ; }
exists() { which "$1" &> /dev/null ; }

[ -d ~/.fonts ] || die \
	'There is no .fonts directory in your home.' \
	'Is fontconfig set up for privately installed fonts?'

ARCHIVE=PowerPointViewer.exe
URL="https://sourceforge.net/projects/mscorefonts2/files/cabs/$ARCHIVE"

if ! [ -e "$ARCHIVE" ] ; then
	if   exists curl  ; then curl -A '' -LO      "$URL"
	elif exists wget  ; then wget -U ''          "$URL"
	elif exists fetch ; then fetch --user-agent= "$URL"
	else die 'You have neither curl nor wget nor fetch.' \
		'Please manually download this file first:' "$URL"
	fi
fi

TMPDIR=`mktemp -d`
trap 'rm -rf "$TMPDIR"' EXIT INT QUIT TERM

cabextract -L -F ppviewer.cab -d "$TMPDIR" "$ARCHIVE"

cabextract -L -F '*.TT[FC]' -d ~/.fonts "$TMPDIR/ppviewer.cab"

( cd ~/.fonts && mv cambria.ttc cambria.ttf && chmod 600 \
	calibri{,b,i,z}.ttf cambria{,b,i,z}.ttf candara{,b,i,z}.ttf \
	consola{,b,i,z}.ttf constan{,b,i,z}.ttf corbel{,b,i,z}.ttf )

fc-cache -fv ~/.fonts

sudo rm ~/Downloads/$ARCHIVE

echo "Provisioning of this system is complete."

exit 0