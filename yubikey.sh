#!/bin/bash
# 
# Setup Yubikey authentication
sudo bash -c -u $SUDO_USER 'mkdir -p /home/$SUDO_USER/.config/Yubico'
read -p "Insert your primary Yubikey, then press enter to continue."
echo "Enter your PIN if needed, then touch the contact on your primary Yubikey."
sudo bash -c -u $SUDO_USER 'pamu2fcfg > /home/$SUDO_USER/.config/Yubico/u2f_keys'
read -p "Remove your primary Yubikey,  insert your backup key, then press enter to continue."
echo "Enter your PIN if needed, then touch the contact on your backup Yubikey."
sudo bash -c -u $SUDO_USER 'pamu2fcfg >> /home/$SUDO_USER/.config/Yubico/u2f_keys'
echo "Setting authorization requirements..."
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/sudo
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/gdm-password
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/login
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/su
sudo sed -i '/@include common-auth/aauth       required   pam_u2f.so' /etc/pam.d/sudo-i

echo "Validating authorization requirements..."
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo "sudo failed"; else echo "sudo passed"; fi
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo "gdm-password failed"; else echo "gdm-password passed"; fi
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo "login failed"; else echo "login passed"; fi
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo "su failed"; else echo "su passed"; fi
cat /etc/pam.d/sudo-i | if ! grep -q pam_u2f.so; then echo "sudo-i failed"; else echo "sudo-i passed"; fi
