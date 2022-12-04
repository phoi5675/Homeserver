#!/bin/bash

set_ufw() {
    local default_config="/etc/default/ufw"
    local ufw_sysctl="/etc/ufw/sysctl.conf"
    local sysctl="/etc/sysctl.conf"
    local ufw_before="/etc/ufw/before.rules"

    # echo "Install ufw..."
    # sudo apt-get update -qq && sudo apt-get install ufw -y -qq

    echo "Enable port forwarding..."
    sudo sed -i '/net\/ipv4\/ip_forward/s/^#//g' "${ufw_sysctl}"
    sudo sed -i 'net.ipv4.ip_forward/s/^#//g' "${sysctl}"
    echo "Add nonlocal bind"
    sudo cat >>"${sysctl}" <<EOF
# For reverse proxy
net.ipv4.ip_nonlocal_bind=1

EOF
    echo "Set ufw configs..."
    sudo sed -i 's/DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/g' "${default_config}"

    echo "Set MASQUERADE..."
    local insert_pos="$(($(cat \/etc\/ufw\/before.rules | wc -l)))"
    local masquerade="
# NAT Table rules 
*nat
:POSTROUTING ACCEPT [0:0]

# Forward traffic from ${LOC_NAT} to ${WAN_IFACE} 
-A POSTROUTING -s ${LOC_NAT} -o ${WAN_IFACE} -j MASQUERADE 

COMMIT
"
    # echo "${before_rules}" >>"${ufw_before}"
    cat >>"${ufw_before}" <<EOF
${masquerade}
EOF
    # sudo sed -i "${insert_pos}i ${before_rules}" "${ufw_before}"
    local http=8000
    local https=8443
    local tcp_port=8001
    local admin_port=2048
    echo "Setup incoming port http:\"${http}\" https:\"${https}\" tcp port:\"${tcp_port}\""
    sudo ufw allow ${http}/tcp
    sudo ufw allow ${https}/tcp
    sudo ufw allow ${tcp_port}/tcp

    local internal_net="172.31.0.0/24"
    echo "Allow ssh port from internal network(\"${internal_net}\")"
    sudo ufw allow in on ${WAN_IFACE} from ${internal_net} to any port 22
    echo "Allow internal network access from wlan(\"${internal_net}\")"
    sudo ufw allow in on ${WAN_IFACE} from ${internal_net} to any port ${admin_port}

    echo "Restart ufw..."
    sudo ufw disable && sudo ufw enable
}

set_ufw
