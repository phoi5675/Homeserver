# Dev

Create VPN environment via UTM / ubuntu

# Setup

- Install ubuntu-server on UTM
- Install guest-tools

```shell
sudo apt-get update && sudo apt-get install -y spice-vdagent spice-webdavd
```

- Copy & paste contents in [vm_setup.sh](./vm_setup.sh)
- run vm_setup.sh in VM
