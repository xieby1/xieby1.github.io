#!/usr/bin/env bash

# DONE: sudo broken inside container
#       https://www.redhat.com/sysadmin/sudo-rootless-podman
#   tldr: not recommend use su/sudo in rootless container

# create image
CREATE_IMAGE() {
    VER=$1

    mkdir -p /tmp/u${VER}
    echo "FROM ubuntu:${VER}.04" > /tmp/u${VER}/Dockerfile

    # buildah default not save intermediate layers,
    # it seems podman layers default true?
    # ~~one RUN command, avoid redundent layers~~
    echo "RUN echo 'root:miqbxgyfdA.PY' | chpasswd -e" >> /tmp/u${VER}/Dockerfile
    echo "RUN useradd -u ${UID} -G users,sudo -p miqbxgyfdA.PY -s /bin/bash xieby1" >> /tmp/u${VER}/Dockerfile
    echo "RUN sed -i 's/http.*com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list" >> /tmp/u${VER}/Dockerfile
    # echo "RUN echo 'Acquire::http::Proxy \"http://127.0.0.1:8889\";' > /etc/apt/apt.conf" >> /tmp/u${VER}/Dockerfile
    echo "RUN apt update" >> /tmp/u${VER}/Dockerfile
    echo "RUN apt install -y sudo tmux" >> /tmp/u${VER}/Dockerfile

    sudo podman build --network=host -t u${VER} /tmp/u${VER}
}

# podman volumes always owned by root:
#   https://github.com/containers/podman/issues/2898
CREATE_CONTAINER() {
    VER=$1

    CMD=(
    "sudo"
    "podman" "run"

    "-u" "xieby1" # [root container]
    # "--userns=keep-id" # [rootless container]

    #"-d" # deamon, not exit
    "--rm" # exit then remove this container
    "--env" "debian_chroot=u${VER}"
    # "-h" "container-u${VER}" # host name
    "-h" "localhost" # host name # avoid edit /etc/hosts
    "--name='u${VER}'" # container name

    "-v" "/home/xieby1:/home/xieby1"
    "-v" "/nix:/nix" # make sure symbol links in home work

    "-w" "/home/xieby1" # working directory

    # this will cause guest /etc/hosts override by host's
    # use host ip instead, see host's ip address
    "--network=host" # use host network stack

    "-it"
    "u${VER}"
#    "/usr/bin/tmux"
    )

    eval "${CMD[@]}"
}


OPTIONS=(
    "-h"
    "-c"
    "-v"
)

CREATE="no"
VER=22
while [[ ${OPTIND} -le $# ]]
do
    getopts "lhcv:" opt
    case "${opt}" in
    l)
        echo "${OPTIONS[@]}"
        exit 0;
    ;;
    h)
        echo "ubuntu container"
        echo "Usage: ${0##*/} [-h] [-c] [-v <VER>]"
        echo "  run with no arg: enter a ubuntu container"
        echo "  -c: reate a ubuntu container image"
        echo "  -h: show this help"
        echo "  -v <VER>: set ubuntu version, default is 20"
        exit 0;
    ;;
    c)
        CREATE="yes"
    ;;
    v)
        VER=${OPTARG}
        echo ${OPTARG}
    ;;
    *)
        shift
    esac
done

if [[ "${CREATE}" == "yes" ]]
then
    CREATE_IMAGE ${VER}
else
    CREATE_CONTAINER ${VER}
fi
