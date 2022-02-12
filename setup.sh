#!/usr/bin/env bash

clean=""
docker=""
vlan=""
hostname=""

print_usage() {
  printf "Usage: ./setup.sh [-c (do not backup configuration files)] [-d (setup docker)] [-v (enable vlans)]"
}

while getopts "h:cdv" flag; do
  case "${flag}" in
    c) clean="true" ;;
    d) docker="true" ;;
    v) vlan="true" ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Aliases
if [ "$clean" != "true" ]; then
  cp ~/.bash_aliases ~/.bash_aliases.orig
fi

cp ./bash_aliases ~/.bash_aliases

# SSH hardening
if [ "$clean" != "true" ]; then
  sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
fi

sudo cp ./sshd_config /etc/ssh/sshd_config

sudo apt update && sudo apt upgrade -y

if [ "$vlan" == "true" ]; then
  sudo apt install vlan
  cat > /etc/network/interfaces.d/vlans << EOL
# Update 10 to desired VLAN
#auto eth0.10
#iface eth0.10 inet manual
#  vlan-raw-device eth0
EOL
  cat >> /etc/dhcpcd.conf << EOL
# Static IP: LAN
#interface eth0
#static ip_address=192.168.0.10/24
#static routers=192.168.0.1
#static domain_name_servers=192.168.0.10 192.168.0.10

# Static IP: VLAN 10
#interface eth0.10
#static ip_address=192.168.10.2/24
#static routers=192.168.10.1
#static domain_name_servers=
EOL
  echo "VLANS enabled, but not yet configured!"
  echo "The following files must be configured to support the desired VLANs:"
  echo "  * /etc/network/interfaces.d/vlans"
  echo "  * /etc/dhcpcd.conf"
  echo "Then reboot and run hostname -I to verify changes"
fi

# Docker
if [ "$docker" == "true" ]; then
  sudo apt install git docker.io docker-compose dnsutils -y
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
fi

# RPI config
#sudo raspi-config

# Update bootloader
sudo rpi-eeprom-update -a

# Static IP
echo "Remember to edit /etc/dhcpcd.conf to set static IP and DNS"

# Update hostname
originalhostname=$(cat /etc/hostname)

echo "Current hostname is $originalhostname"
echo "Enter new hostname: "
read newhostname

sudo sed -i "s/$originalhostname/$newhostname/g" /etc/hosts
sudo sed -i "s/$originalhostname/$newhostname/g" /etc/hostname

echo "Hostname is now $newhostname"

# Reboot
read -s -n 1 -p "Press any key to reboot"
sudo reboot
