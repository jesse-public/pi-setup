#!/usr/bin/env bash

#if [ "$#" -ne 1 ]
#then
#  echo "Usage: ./setup arg1"
#  exit 1
#fi

echo 'alias ll="ls -la"' >> ~/.bash_aliases
echo '' >> ~/.bash_aliases

sudo apt update
sudo apt upgrade -y
sudo apt install git docker.io docker-compose dnsutils -y
sudo usermod -aG docker ${USER}

sudo raspi-config

sudo reboot now
