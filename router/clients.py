from client_interface import *
from typing import *

CLIENTS: Dict[str, NetworkClient] = {
    'Minjaes-MBP': NetworkClient(
        hostname='Minjaes-MBP',
        mac_addr='',
        ip_addr='172.31.0.2'),
    'proxmox': NetworkClient(
        hostname='proxmox',
        mac_addr='',
        ip_addr='172.31.0.99'),
    'windows': NetworkClient(
        hostname='windows',
        mac_addr='',
        ip_addr='172.31.0.102'),
    'truenas': NetworkClient(
        hostname='truenas',
        mac_addr='',
        ip_addr='172.31.0.103'),
    'docker': NetworkClient(
        hostname='docker',
        mac_addr='',
        ip_addr='172.31.0.104')
}
