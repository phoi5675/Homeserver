from typing import *


class NetworkClient:
    def __init__(self, hostname: str, mac_addr: str, ip_addr: str):
        self.hostname: str = hostname
        self.mac_addr: str = mac_addr
        self.ip_addr: str = ip_addr
