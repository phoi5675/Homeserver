# Dev

Create VPN environment via docker / gui

# Setup

## On mac

```shell
brew install socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

```shell
brew install xquartz
```

- Turn on **allow connections from network clients** on xquartz > security

- Edit ${IP} in [Dockerfile](./Dockerfile)

- Create vpn_config.sh based on format below.

```shell
# Content of vpn_config.sh
export VPN_NAME="VPN"
export IP_ADDR=""
export PSK=""
export USER=""
export USER_PWD=""
```

- Build image

```shell
docker build -f ./Dockerfile -t vpnimg .
```

# Run

```shell
docker run -d --name vpnContainer --privileged vpnimg
```

# After setup

```shell
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" && \
    sudo docker exec -d vpnContainer firefox
```
