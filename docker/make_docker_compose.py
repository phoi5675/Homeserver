import yaml
import os
from typing import *


COMPOSE_FOLDER = 'docker-compose'
VOLUME_YML = 'docker-volume.yml'
OUTPUT = 'docker-compose.yml'


def file_to_yaml_obj(filepath: str):
    with open(rf'{filepath}') as file:
        return yaml.full_load(file)


if __name__ == '__main__':
    yaml_files: List[str] = os.listdir(COMPOSE_FOLDER)
    output_yaml = file_to_yaml_obj(OUTPUT)
    volume_yaml = file_to_yaml_obj(VOLUME_YML)

    yaml_objs = []
    for yaml_file in yaml_files:
        yaml_objs.append(file_to_yaml_obj(f'{COMPOSE_FOLDER}/{yaml_file}'))

    # merge docker-compose services
    output_yaml['services'].clear()
    for yaml_obj in yaml_objs:
        output_yaml['services'].update(yaml_obj['services'])

    # merge docker volumes
    output_yaml['volumes'].clear()
    output_yaml['volumes'].update(volume_yaml['volumes'])

    with open(OUTPUT, 'w') as output_file:
        yaml.safe_dump(output_yaml, output_file)
    exit(0)
