echo \
    "#/usr/bin/bash

TZ="Asia/Seoul"

sudo ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime &&
    sudo echo "${TZ}" >/etc/timezone

# Change apt server to korea
sudo sed -i 's/ports/kr.ports/g' /etc/apt/sources.list

# Install packages
sudo apt-get update

sudo apt-get install -y ubuntu-desktop

sudo apt-get install -y chromium-browser

sudo apt-get install fonts-nanum -y -f
" >vm_setup.sh
