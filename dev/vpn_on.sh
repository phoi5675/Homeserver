#!/usr/bin/bash

source ./vpn_config.sh
# Content of vpn_config.sh
# export VPN_NAME="VPN"
# export IP_ADDR=""
# export PSK=""
# export USER=""
# export USER_PWD=""

echo "Setup VPN..."
echo ""

nmcli connection add connection.id \
    "${VPN_NAME}" con-name "${VPN_NAME}" type VPN vpn-type l2tp \
    ifname -- connection.autoconnect no ipv4.method auto \
    vpn.data "gateway = \"${IP_ADDR}\", ipsec-enabled = yes, ipsec-psk = 0s"$(base64 <<<\"${PSK}\" | rev | cut -c2- | rev)"=, mru = 1400, mtu = 1400, password-flags = 0, refuse-chap = yes, refuse-mschap = yes, refuse-pap = yes, require-mppe = yes, user = \"${USER}\"" vpn.secrets password=\"${USER_PWD}\"
