#!/usr/bin/env bash

#if [ "$#" -ne 1 ]
#then
#  echo "Usage: ./setup arg1"
#  exit 1
#fi

# Aliases
#cp ~/.bash_aliases ~/.bash_aliases.orig
cp ./bash_aliases ~/.bash_aliases

# SSH hardening
#mv /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
cp ./sshd_config /etc/ssh/sshd_config

# Docker
# sudo apt update
# sudo apt upgrade -y
# sudo apt install git docker.io docker-compose dnsutils -y
# sudo usermod -aG docker ${USER}

# RPI config
# sudo raspi-config
