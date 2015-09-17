#! /bin/sh
# Functions to run or stop quickly an LXD container
# and mount it on host folder with clean rules

LXD_SOURCE_DIR=/var/lib/lxd/containers
LXD_MOUNT_DIR=/lxc
USER_HOST_MOUNT=antitoine
GROUP_HOST_MOUNT=antitoine
UID_GUEST_MOUNT=101001
GID_GUEST_MOUNT=101001
lxd-bindfs-umount() {
    if [ -z "$1" ]; then
        echo "lxd-bindfs-umount <container name>"
    elif [ ! "$(ls -A $LXD_MOUNT_DIR/$1 )" ]; then
        echo "The mount directory is empty : $LXD_MOUNT_DIR/$1"
    else
        sudo umount /lxc/$1 && echo "Umount done (in $LXD_MOUNT_DIR/$1)"
    fi
}
lxd-bindfs-mount() {
    if [ $# -ne 5 ]; then
        echo "lxd-bindfs-mount <container name> <host user> <host group> <guest user> <guest group>"
    elif [ "$(ls -A $LXD_MOUNT_DIR/$1 )" ]; then
        echo "The mount directory is not empty : $LXD_MOUNT_DIR/$1"
    else
        sudo bindfs --force-user=$2 --force-group=$3 --create-for-user=$4 --create-for-group=$5 $LXD_SOURCE_DIR/$1/rootfs $LXD_MOUNT_DIR/$1 && echo "Mount done (in $LXD_MOUNT_DIR/$1)"
    fi
}
lxd-stop() {
    if [ -z "$1" ]; then
        echo "lxd-start <container name>"
    else
        lxc stop $1 && echo "LXD $1 stopped"
        lxd-bindfs-umount $1
    fi
}
lxd-start() {
    if [ -z "$1" ]; then
        echo "lxd-start <container name>"
    else
        lxc start $1 && echo "LXD $1 started"
        lxd-bindfs-mount $1 $USER_HOST_MOUNT $GROUP_HOST_MOUNT $UID_GUEST_MOUNT $GID_GUEST_MOUNT
    fi
}
_lxdListComplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls $LXD_MOUNT_DIR)" -- $cur) )
}
complete -F _lxdListComplete lxd-start
complete -F _lxdListComplete lxd-stop
