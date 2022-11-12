#!/bin/bash
# TODO: Add script for date / time settings.

# Edit interface name based on network interfaces
readonly INB_IFACE=ens18  # Inbound
readonly OUTB_IFACE=ens19 # Outbound

edit_interface() {
    local interfaces="/etc/network/interfaces"
    echo "Install net-tools"
    sudo apt-get update && sudo apt-get install net-tools -y --quiet
    echo "Backup ${interfaces}..."
    sudo mv "${interfaces}" "${interfaces}.bak"
    echo "Edit ${interfaces}..."
    sudo touch "${interfaces}"
    sudo cat >"${interfaces}" <<EOF
# The loopback network
auto lo
iface lo inet loopback

# Outbound
auto ${OUTB_IFACE}
iface ${OUTB_IFACE} inet dhcp

# Inbound
auto ${INB_IFACE}
iface ${INB_IFACE} inet static
address 10.10.10.1
netmask 255.255.255.0

# Private gateway for VM and CT

# Router setting
post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
post-up   iptables -t nat -A POSTROUTING -s '10.10.10.0/24' -o ${OUTB_IFACE} -j MASQUERADE
post-down iptables -t nat -D POSTROUTING -s '10.10.10.0/24' -o ${OUTB_IFACE} -j MASQUERADE
post-up iptables -t nat -A PREROUTING -i ${OUTB_IFACE} -p tcp --dport 8000 -j DNAT --to 10.10.10.1:80
post-down iptables -t nat -D PREROUTING -i ${OUTB_IFACE} -p tcp --dport 8000 -j DNAT --to 10.10.10.1:80
post-up iptables -t nat -A PREROUTING -i ${OUTB_IFACE} -p tcp --dport 8443 -j DNAT --to 10.10.10.1:443
post-down iptables -t nat -D PREROUTING -i ${OUTB_IFACE} -p tcp --dport 8443 -j DNAT --to 10.10.10.1:443
EOF

    echo "Restarting service..."
    sudo service networking restart
    echo "Restarting interfaces..."
    sudo ifconfig "${INB_IFACE}" down
    sudo ifconfig "${INB_IFACE}" up

    sudo ifconfig "${OUTB_IFACE}" down
    sudo ifconfig "${OUTB_IFACE}" up

}

set_nginx() {
    local nginx_dir="/etc/nginx"
    local http_conf_dir=${nginx_dir}"/conf.d"
    local stream_conf_dir=${nginx_dir}"/stream"
    local sites_enabled=${nginx_dir}"/sites-enabled"
    echo "Install nginx..."
    sudo apt-get update
    sudo apt-get install nginx -y --quiet

    echo "Setup nginx..."
    echo "Delete configs in ${sites_enabled}..."
    sudo rm "${sites_enabled}/*"
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

set_host() {
    local hosts="/etc/hosts"
    echo "Set ${hosts}..."
    sudo echo "" >>"${hosts}"
    sudo cat ./hosts >>"${hosts}"
    sudo service networking restart
}

main() {
    edit_interface
    set_host
    set_nginx
}

main 2>&1 | tee -a setup.log
