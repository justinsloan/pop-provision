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

# Define colors using ANSI escape codes
# Example: echo -e "I ${RED}love${ENDCOLOR} Linux"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
ENDCOLOR='\033[0m'

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo -e "${RED}Notice:${ENDCOLOR} Please run as root"
  exit
fi

echo -e "==> ${GREEN}Starting Yubikey setup.${ENDCOLOR}"

# Check for curl
if ! exists nala; then 
    sudo apt -y install nala
fi

# Install U2F library
sudo apt install libu2f-udev libpam-u2f

# Setup Yubikey authentication
sudo -i -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/Yubico
clear

echo -e "Insert your ${GREEN}primary Yubikey${ENDCOLOR}, then press enter to continue."
read -p ""
echo "Enter your PIN if needed, then touch the contact on your primary Yubikey."
sudo -i -u $SUDO_USER pamu2fcfg > /home/$SUDO_USER/.config/Yubico/u2f_keys
echo -e "Remove your primary Yubikey, insert your ${RED}backup key${ENDCOLOR}, then press enter to continue."
read -p ""
echo "Enter your PIN if needed, then touch the contact on your backup Yubikey."
sudo -i -u $SUDO_USER pamu2fcfg >> /home/$SUDO_USER/.config/Yubico/u2f_keys
echo "Setting authorization requirements..."
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/sudo
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/gdm-password
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/login
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/su
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/sudo-i

echo "Validating authorization requirements..."
cat /etc/pam.d/sudo | if ! grep -q pam_u2f.so; then echo -e "sudo ${RED}failed${ENDCOLOR}"; else echo "sudo ${GREEN}passed${ENDCOLOR}"; fi
cat /etc/pam.d/gdm-password | if ! grep -q pam_u2f.so; then echo -e "gdm-password ${RED}failed${ENDCOLOR}"; else echo "gdm-password ${GREEN}passed${ENDCOLOR}"; fi
cat /etc/pam.d/login | if ! grep -q pam_u2f.so; then echo -e "login ${RED}failed${ENDCOLOR}"; else echo "login ${GREEN}passed${ENDCOLOR}"; fi
cat /etc/pam.d/su | if ! grep -q pam_u2f.so; then echo -e "su ${RED}failed${ENDCOLOR}"; else echo "su ${GREEN}passed${ENDCOLOR}"; fi
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo -e "sudo-i ${RED}failed${ENDCOLOR}"; else echo "sudo-i ${GREEN}passed${ENDCOLOR}"; fi
