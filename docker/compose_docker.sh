#!/bin/bash
set_nginx() {
    docker stop nginx

    docker run -d --name nginx \
        --net docker_network \
        --restart always
    --ip ${nginx} \
        --publish 80:80 \
        --publish 443:443 \
        --volume $(pwd)/nginx/:/etc/nginx/templates:ro \
        nginx
}
set_cloud() {
    docker stop nextcloud-aio-mastercontainer

    docker run \
        --sig-proxy=false \
        --name nextcloud-aio-mastercontainer \
        --restart always \
        --ip ${cloud} \
        --publish 8080:8080 \
        -e APACHE_PORT=11000 \
        --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        nextcloud/all-in-one:latest
}
set_photo() {
    docker stop photoprism

    docker run -d \
        --name photoprism \
        --security-opt seccomp=unconfined \
        --security-opt apparmor=unconfined \
        --ip ${photo} \
        -e PHOTOPRISM_UPLOAD_NSFW="true" \
        -e PHOTOPRISM_ADMIN_PASSWORD=${PHOTO_PWD} \
        -volume /photoprism/storage \
        -volume /mnt/Photo:/photoprism/originals \
        photoprism/photoprism
}
set_dashboard() {
    docker stop dashboard

    docker run -d \
        --name=dashboard \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=Asia/Seoul \
        --ip ${dashboard} \
        --restart unless-stopped \
        lscr.io/linuxserver/heimdall:latest
}
create_docker() {
    set_nginx
    set_cloud
    set_photo
    set_dashboard
}
# Check script is running in root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

python3 host_to_env.py --host_path='../router/setups/hosts' --env_path='./env/.env'

(source ./env/.env && source ./env/.env.secret && create_docker)
