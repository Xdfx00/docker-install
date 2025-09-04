#!/bin/bash

source /etc/os-release

# Define color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

set -e

ubuntu_installation() {
  # Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

}

debain_installation() {
  # Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

centos_almalinux_rockylinux_rhel() {
  sudo dnf -y install dnf-plugins-core
  sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/$ID/docker-ce.repo

  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable --now docker
}

archlinux() {
  sudo pacman -Syy --noconfirm docker
  sudo pacman -Syy --noconfirm docker-compose

  sudo systemctl enable --now docker
}

# Detecting OS

if [[ $ID == "ubuntu" ]]; then
  ubuntu_installation
elif [[ "$ID" == "almalinux" || "$ID" == "rocky" || "$ID" == "centos" || "$ID" == "fedora" ]]; then
  centos_almalinux_rockylinux_rhel
elif [[ "$ID" == "debain" ]]; then
  debain_installation
elif [[ "$ID" == "arch" ]]; then
  archlinux 
else
  echo -e "${RED}[ERROR] Unsupported OS. This script supports only Ubuntu, Debain, AlmaLinux, Rockylinux, Centos stream.${NC}"
  exit 1
fi
