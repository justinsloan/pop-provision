#!/bin/bash

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
echo "alias history='history | fzf'" >> /home/$SUDO_USER/.bash_aliases
echo "alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'" >> /home/$SUDO_USER/.bash_aliases
echo "alias dict='dict -d wn'" >> /home/$SUDO_USER/.bash_aliases
echo "alias gpumon='amd-smi monitor -g 0 -p -u -t'" >> /home/$SUDO_USER/.bash_aliases
echo "alias cat='batcat'" >> /home/$SUDO_USER/.bash_aliases
