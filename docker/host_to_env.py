import argparse
import traceback
from typing import *


def host_to_env(host_path: str, env_path: str) -> None:
    try:
        res: List[str] = []
        with open(host_path, 'r') as hostfile:
            line: str = 'init string'
            while line:
                try:
                    line = hostfile.readline().rstrip('\n')
                    ip_addr, hostname = line.split(' ')
                    res.append(f'{hostname}={ip_addr}\n')
                except ValueError:
                    pass
        
        with open(env_path, 'w+') as env_file:
            env_file.writelines(res)
    except Exception:
        traceback.print_exc()

if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--host_path',
        type=str,
        required=True,
        help='hostfile\'s path')
    parser.add_argument('--env_path',
        type=str,
        required=True,
        help='envfile\'s path')
    
    args = parser.parse_args()
    host_to_env(args.host_path, args.env_path)