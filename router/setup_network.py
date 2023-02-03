import subprocess
from typing import *
from clients import CLIENTS
from client_interface import *
from consts import *


def create_hostfile(clients: Dict[str, NetworkClient]) -> None:
    with open('hostfile', 'w') as hostfile:
        for host in clients.values():
            hostfile.write(f'{host.ip_addr} {host.hostname}\n')


def set_ufw(clients: Dict[str, NetworkClient]) -> None:
    ufw_list = [
        ##############
        #   Router   #
        ##############
        # ssh
        subprocess.Popen(
            f'ufw allow from {PRIVATE_NET} to any port 22 proto tcp',
            stdout=subprocess.PIPE
        ),
        ##############
        #   Private  #
        ##############
        # http
        subprocess.Popen(
            f'ufw allow from any to {clients["docker"].ip_addr} port 8080 proto tcp',
            stdout=subprocess.PIPE
        ),
        # https
        subprocess.Popen(
            f'ufw allow from any to {clients["docker"].ip_addr} port 8443 proto tcp',
            stdout=subprocess.PIPE
        ),
    ]

    for proc in ufw_list:
        output, error = proc.communicate()


if __name__ == '__main__':
    create_hostfile(clients=CLIENTS)

    exit(0)
