#!/usr/bin/env bash

# TODO: /debootstrap/debootstrap --second-stage
#       failed, because of no mail group
#       see /debootstrap/debootstrap.log

CHROOT=~/Img/chroot_u22_a64.1
# $HOME is defined in host bash
#HOME=/home/xieby1

# ${HOME} /proc /sys /dev
DIRS="/nix /run/binfmt"
for dir in ${DIRS}; do
    sudo mkdir -p ${CHROOT}${dir}
    sudo mount --bind ${dir} ${CHROOT}${dir}
done
FILES="/etc/hosts /etc/passwd /etc/group"
for file in ${FILES}; do
    sudo touch ${CHROOT}${file}
    sudo mount --bind ${file} ${CHROOT}${file}
done
echo miao
CMD=(
    "sudo"
    "chroot"
    # "--userspec=xieby1:users"
    "${CHROOT}"
    "/usr/bin/env"
    # start with an empty environment
    "-i"
    "HOME=${HOME}"
    "TERM=$TERM"
    "PS1='\u:\w\$ '"
    "PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"
    "/bin/bash"
)
eval "${CMD[@]}"
echo wang

for dir in ${DIRS}; do
    sudo umount ${CHROOT}${dir}
done
for file in ${FILES}; do
    sudo umount ${CHROOT}${file}
done
