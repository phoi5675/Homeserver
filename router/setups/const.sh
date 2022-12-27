#!/bin/bash

# Edit interface name based on network interfaces
export WAN_IFACE=ens18 # Inbound
export LAN_IFACE=ens19 # Outbound

export LOC_NAT="172.31.0.0/16"

export networkd="systemd-networkd.service"
