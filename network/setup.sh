#!/bin/bash
# TODO: Add script for date / time settings.
# TODO: Add korean font setup
# TODO: fix inserting configs for ufw before.rules

# Edit interface name based on network interfaces
readonly WAN_IFACE=ens18 # Inbound
readonly LAN_IFACE=ens19 # Outbound

readonly LOC_NAT="10.10.10.0/24"

networkd="systemd-networkd.service"

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
auto ${LAN_IFACE}
iface ${LAN_IFACE} inet static
address 10.10.10.1
netmask 255.255.255.0

# WAN 
auto ${WAN_IFACE}
iface ${WAN_IFACE} inet dhcp

# Private gateway for VM and CT
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
    sudo apt-get -qq update
    sudo apt-get -qq install nginx -y

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
    local default_config="/etc/default/ufw"
    local ufw_sysctl="/etc/ufw/sysctl.conf"
    local ufw_before="/etc/ufw/before.rules"

    # echo "Install ufw..."
    # sudo apt-get update -qq && sudo apt-get install ufw -y -qq

    echo "Enable port forwarding..."
    sudo sed -i '/net\/ipv4\/ip_forward/s/^#//g' "${ufw_sysctl}"
    echo "Set ufw configs..."
    sudo sed -i 's/DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/g' "${default_config}"

    echo "Set MASQUERADE..."
    local insert_pos="$(($(cat \/etc\/ufw\/before.rules | wc -l)))"
    local masquerade="\\
# NAT Table rules \\
*nat \\
:POSTROUTING ACCEPT \[0:0] \\
\\
# Forward traffic from ${LOC_NAT} to ${WAN_IFACE} \\
-A POSTROUTING -s ${LOC_NAT} -o ${WAN_IFACE} -j MASQUERADE \\
\\
COMMIT
\\"
    echo "${before_rules}" >>"${ufw_before}"
    # sudo sed -i "${insert_pos}i ${before_rules}" "${ufw_before}"
    local http=8000
    local https=8443
    local tcp_port=8001
    echo "Setup incoming port http:\"${http}\" https:\"${https}\" tcp port:\"${tcp_port}\""
    sudo ufw allow ${http}/tcp
    sudo ufw allow ${https}/tcp
    sudo ufw allow ${tcp_port}/tcp

    local internal_net="192.168.0.0/24"
    echo "Allow ssh port from internal network(\"${internal_net}\")"
    sudo ufw allow in on ${WAN_IFACE} from ${internal_net} to any port 22

    echo "Restart ufw..."
    sudo ufw disable && sudo ufw enable
}

set_certbot() {
    echo "Get TLS certificate..."
    echo "Installing certbot..."
    sudo apt-get update -qq &&
        sudo apt-get install certbot python3-certbot-nginx -y -qq
    echo "Issuing certificates..."
    echo "Add values to DNS Server MANUALLY!"
    sudo certbot certonly --manual --preferred-challenges \
        dns -d "*.phoiweb.com" -d "phoiweb.com"
    # TODO: Add auto-renewal script
    # 0 0 1 * * /bin/bash -l -c 'certbot renew --quiet'
}

set_host() {
    local hosts="/etc/hosts"
    echo "Set ${hosts}..."
    sudo echo "" >>"${hosts}"
    sudo cat ./hosts >>"${hosts}"
    sudo systemctl restart "${networkd}"
}

set_apt_mirror() {
    sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
    sudo apt-get -qq update
}

main() {
    # Check script is running in root
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit
    fi
    set_apt_mirror
    set_ufw
    edit_interface
    # set_certbot
    set_host
    set_nginx
}

main 2>&1 | tee -a setup.log
