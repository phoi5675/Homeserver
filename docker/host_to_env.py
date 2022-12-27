import traceback
from os import *
from typing import *


# TODO: Test this function
def host_to_env(host_path: str, env_path: str) -> None:
    try:
        res: List[str] = []
        with open(host_path, 'r') as hostfile:
            line: str = 'init string'
            while line:
                line = hostfile.readline().strip('\n')
                ip_addr, hostname: str = line.split()
                res.append(f'{hostname}={ip_addr}')
        
        with open(env_path, 'w') as env_file:
            env_file.writelines(res)
    except Exception:
        traceback.print_exc()