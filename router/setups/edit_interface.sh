#!/bin/bash

edit_interface() {
    local interfaces="/etc/network/interfaces"
    echo "Install net-tools"
    sudo apt-get -qq update && sudo apt-get --quiet install net-tools -y
    echo "Backup ${interfaces}..."
    sudo mv "${interfaces}" "${interfaces}.bak"
    echo "Edit ${interfaces}..."
    sudo touch "${interfaces}"
    sudo cat >"${interfaces}" <<EOF
# The loopback network
auto lo
    iface lo inet loopback

# LAN
# Private gateway for VM and CT
auto ${LAN_IFACE}
    iface ${LAN_IFACE} inet static
    address 172.31.0.1
    netmask 255.255.255.0

# WAN 
auto ${WAN_IFACE}
    iface ${WAN_IFACE} inet dhcp

EOF

    echo "Restarting service..."
    sudo systemctl restart "${networkd}"
    echo "Restarting interfaces..."
    sudo ifconfig "${WAN_IFACE}" down
    sudo ifconfig "${WAN_IFACE}" up

    sudo ifconfig "${LAN_IFACE}" down
    sudo ifconfig "${LAN_IFACE}" up

}

edit_interface
