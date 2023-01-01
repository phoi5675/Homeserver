# Dev

Create VPN environment via UTM / ubuntu

# Setup

- Install ubuntu-server on UTM
- Install guest-tools

```shell
sudo apt-get update && \
    sudo apt-get install -y spice-vdagent spice-webdavd davfs2 && \
    sudo reboot
```

- Edit Shared > Directory Share Mode to SPICE WebDAV
- Mount shared folder

```shell
$ sudo mkdir /mnt/shared
# empty user and pass here
$ sudo mount -t davfs -o noexec http://127.0.0.1:9843/ /mnt/shared/
```

- run [vm_setup.sh](./vm_setup.sh) in VM
- shutdown and restart vm(if reboot not works)

## VPN Setup

- Install network-manager-l2tp(included in vm_setup.sh)
- Edit yml file in `/etc/netplan/`

```shell
network:
    renderer: NetworkManager # add this line
    ethernets:
        enp2s0:
            dhcp4: true
    version: 2
```

- Run `sudo netplan apply`
- Configure VPN in settings(GUI)
