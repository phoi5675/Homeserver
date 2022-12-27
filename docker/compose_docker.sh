#!/bin/bash

python3 host_to_env.py --host_path='../router/setups/hosts' --env_path='./env/.env'

sudo docker-compose $(find ./ -name docker*.yml | sed -e 's/^/-f /') up -d
