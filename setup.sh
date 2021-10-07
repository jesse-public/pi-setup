#!/usr/bin/env bash

if [ "$#" -ne 1 ]
then
  echo "Usage: ./setup desired-hostname"
  exit 1
fi

echo 'alias ll="ls -la"' >> ~/.bash_aliases
echo '' >> ~/.bash_aliases

sudo echo $1 >> /etc/hostname

sudo apt update
sudo apt upgrade -y
sudo apt install git docker.io docker-compose dnsutil -y
sudo usermod -aG docker ${USER}
sudo reboot now
