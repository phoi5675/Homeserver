#!/bin/bash
# TODO: Add script for date / time settings.

# Edit interface name based on network interfaces
readonly WAN_IFACE=eth0 # Inbound
readonly LAN_IFACE=eth1 # Outbound

networkd="systemd-networkd.service"

edit_interface() {
    local interfaces="/etc/network/interfaces"
    echo "Install net-tools"
    sudo apt-get --quiet update && sudo apt-get --quiet install net-tools -y
    echo "Backup ${interfaces}..."
    sudo mv "${interfaces}" "${interfaces}.bak"
    echo "Edit ${interfaces}..."
    sudo touch "${interfaces}"
    sudo cat >"${interfaces}" <<EOF
# The loopback network
auto lo
iface lo inet loopback

# LAN
auto ${WAN_IFACE}
iface ${WAN_IFACE} inet static
address 10.10.10.1
netmask 255.255.255.0

# WAN 
auto ${LAN_IFACE}
iface ${LAN_IFACE} inet dhcp

# Private gateway for VM and CT

# Router setting
post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
EOF

    echo "Restarting service..."
    sudo systemctl restart "${networkd}"
    echo "Restarting interfaces..."
    sudo ifconfig "${WAN_IFACE}" down
    sudo ifconfig "${WAN_IFACE}" up

    sudo ifconfig "${LAN_IFACE}" down
    sudo ifconfig "${LAN_IFACE}" up

}

set_nginx() {
    local nginx_dir="/etc/nginx"
    local http_conf_dir=${nginx_dir}"/conf.d"
    local stream_conf_dir=${nginx_dir}"/stream"
    local sites_available=${nginx_dir}"/sites-available"
    echo "Install nginx..."
    sudo apt-get --quiet update
    sudo apt-get --quiet install nginx -y

    echo "Setup nginx..."
    # echo "Delete configs in ${sites_available}..."
    # ls -alF "${sites_available}"
    # sudo rm "${sites_available}/default"
    echo "Copy http.conf..."
    sudo cp ./http.conf "${http_conf_dir}/"

    echo "Setup stream folder and copy files..."
    sudo mkdir -p "${stream_conf_dir}"
    sudo cp ./tcp.conf "${stream_conf_dir}/tcp.conf"

    echo "Add stream config in ${nginx_dir}/nginx.conf"
    sudo cat >>"${nginx_dir}/nginx.conf" <<EOF

# Configuration for other protocols(ssh, rdp, ...)
stream {
    include ${stream_conf_dir}/*;
}
EOF

    echo "Restart nginx service..."
    sudo service nginx restart
}

set_ufw() {
    echo "Set ufw configs..."
}

set_host() {
    local hosts="/etc/hosts"
    echo "Set ${hosts}..."
    sudo echo "" >>"${hosts}"
    sudo cat ./hosts >>"${hosts}"
    sudo systemctl restart "${networkd}"
}

set_apt_mirror() {
    sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
    sudo apt-get -q update
}

main() {
    set_apt_mirror
    edit_interface
    set_host
    set_nginx
}

main 2>&1 | tee -a setup.log
