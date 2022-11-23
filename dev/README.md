# Dev

Create VPN environment via UTM / ubuntu

# Setup

- Install ubuntu-server on UTM
- Install guest-tools

```shell
sudo apt-get update && \
    sudo apt-get install -y spice-vdagent spice-webdavd davfs2
```

- Mount shared folder

```shell
$ sudo mkdir /mnt/shared
# empty user and pass here
$ sudo mount -t davfs -o noexec http://127.0.0.1:9843/ /mnt/shared/
```

- run [vm_setup.sh](./vm_setup.sh) in VM
