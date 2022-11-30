#!/usr/bin/env bash

CHROOT=/home/chroot/u20
# $HOME is defined in host bash
#HOME=/home/xieby1

sudo mount --bind ${HOME} ${CHROOT}${HOME}

CMD=(
    "sudo"
    "chroot"
    "--userspec=xieby1:users"
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
