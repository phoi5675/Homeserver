#!/bin/bash

set_misc() {
    echo "Set timezone to KST..."
    TZ="Asia/Seoul"

    sudo ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime &&
        sudo echo "${TZ}" >/etc/timezone

    echo "Install nanum-fonts..."
    sudo apt-get update && sudo apt-get install fonts-nanum

}

set_misc
