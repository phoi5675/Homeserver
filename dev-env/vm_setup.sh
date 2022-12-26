#/usr/bin/bash

TZ="Asia/Seoul"

sudo ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime &&
    sudo echo "${TZ}" >/etc/timezone

# Change apt server to korea
sudo sed -i 's/\/ports./\/kr.ports./g' /etc/apt/sources.list

# Install packages
sudo apt-get update

sudo apt-get install -y -f chromium-browser

sudo apt-get install -y -f fonts-nanum

sudo apt-get install -y ubuntu-desktop

# VPN Packages
sudo add-apt-repository ppa:nm-l2tp/network-manager-l2tp
sudo apt-get update
sudo apt-get install -y network-manager-l2tp network-manager-l2tp-gnome
