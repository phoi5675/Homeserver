#!/bin/bash

readonly SETUPS="./setups"

main() {
    # Check script is running in root
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit
    fi

    # Set working directory with pushd
    pushd ${SETUPS}
    . const.sh
    . set_apt_mirror.sh
    . set_misc.sh
    . set_ufw.sh
    . edit_interface.sh
    # . set_certbot.sh
    . set_host.sh
    . set_nginx.sh
    popd
}

main 2>&1 | tee -a setup.log
