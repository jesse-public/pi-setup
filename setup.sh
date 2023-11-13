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

sudo apt update && sudo apt upgrade -y

# Add bash aliases
if [ "$clean" != "true" ]; then
  cp ~/.bash_aliases ~/.bash_aliases.orig
fi
cp ./bash_aliases ~/.bash_aliases

# Harden SSH
if [ "$clean" != "true" ]; then
  sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
fi
sudo cp ./sshd_config /etc/ssh/sshd_config

# Add example static IP configuration
cat >> /etc/network/interfaces << EOL
# Example static IP configuration:
#auto eth0
#iface eth0 inet static
#  address 192.168.0.200
#  netmask 255.255.255.0
#  gateway 192.168.0.1
#  dns-nameservers 192.168.0.1
EOL

# Add example VLAN configuration
if [ "$vlan" == "true" ]; then
  sudo apt install vlan
  mkdir -p /etc/network/interfaces.d
  cat > /etc/network/interfaces.d/vlans << EOL
# Example VLAN configuration:
#auto eth0.10
#iface eth0.10 inet static
#  vlan-raw-device eth0
#  address 192.168.10.200
#  netmask 255.255.255.0
#  gateway 192.168.10.1
#  dns-nameservers 192.168.10.1
EOL
fi

# Docker Setup
if [ "$docker" == "true" ]; then
  sudo apt install git docker.io docker-compose dnsutils -y
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
fi

# Upgrades
# RPI config
#sudo raspi-config

# Update firmware
#sudo rpi-update

# Update bootloader
sudo rpi-eeprom-update -a

# Hostname
originalhostname=$(cat /etc/hostname)
echo "Current hostname is $originalhostname"
echo "Enter new hostname: "
read newhostname
sudo sed -i "s/$originalhostname/$newhostname/g" /etc/hosts
sudo sed -i "s/$originalhostname/$newhostname/g" /etc/hostname
echo "Hostname is now $newhostname"

# Print next steps
echo "******************"
echo "*** Next steps ***"
echo "  --> Configure static IP. A template was added to:"
echo "      /etc/network/interfaces"

if [ "$vlan" == "true" ]; then
  echo "  --> Configure VLANs. A template was added to:"
  echo "      /etc/network/interfaces.d/vlans"
  echo "Afterwards, reboot and run hostname -I to verify changes"
fi

echo ""
echo "After performing above steps, you should reboot."
