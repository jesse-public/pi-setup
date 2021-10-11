#!/usr/bin/env bash

clean=''
docker=''

print_usage() {
  printf "Usage: ./setup.sh [-c (do not backup configuration files)] [-d (setup docker)]"
}

while getopts 'cd' flag; do
  case "${flag}" in
    c) clean='true' ;;
    d) docker='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Aliases
if [ clean != 'true' ]; then
  cp ~/.bash_aliases ~/.bash_aliases.orig
fi

cp ./bash_aliases ~/.bash_aliases

# SSH hardening
if [ clean != 'true' ]; then
  sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
fi

sudo cp ./sshd_config /etc/ssh/sshd_config

sudo apt update && sudo apt upgrade -y

# Docker
if [ docker == 'true' ]; then
  sudo apt install git docker.io docker-compose dnsutils -y
  sudo usermod -aG docker ${USER}
fi

# RPI config
sudo raspi-config
