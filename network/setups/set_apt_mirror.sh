#!/bin/bash

set_apt_mirror() {
    sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
    sudo apt-get -qq update
}

set_apt_mirror
