#/usr/bin/env bash

# parsing arguments
VERSION=latest
while [[ ${OPTIND} -le $# ]]; do
    getopts "lhe" opt
    case "${opt}" in
    l|h)
        echo "aarch64 riscv64 x86_64 16.04 18.04 20.04 22.04 22.10 23.04 latest -h -e"
        exit 0
    ;;
    e)
        ECHO=1
    ;;
    *)
        arg=${!OPTIND}
        case "$arg" in
        aarch64|riscv64|x86_64)
            ARCH=$arg
        ;;
        *)
            VERSION=$arg
        ;;
        esac
        shift
    ;;
    esac
done
NAME=ubuntu-${ARCH}

OPTS=(
    "-u root"
    # "--userns=keep-id" # [rootless container]
    "--env debian_chroot=$NAME"
    # "-h" "container-$NAME" # host name
    "-h localhost" # host name # avoid edit /etc/hosts
    "--name=$NAME-$VERSION" # container name

    "-v $HOME:$HOME"
    "-v $HOME:/root"
    "-v /nix:/nix" # make sure symbol links in home work
    "-v /run/binfmt:/run/binfmt"
    "-w $PWD" # working directory

    # this will cause guest /etc/hosts override by host's
    # use host ip instead, see host's ip address
    "--network=host" # use host network stack

    "-it"
    "$NAME:$VERSION"
    "/bin/bash"
)

# Pull image
podman images ${NAME}:${VERSION} | grep ${NAME} &> /dev/null
if [[ $? != 0 ]]; then
    if [[ $ARCH == "riscv64" ]]; then
        image_id=$(podman pull --arch ${ARCH} riscv64/ubuntu:$VERSION)
    else
        image_id=$(podman pull --arch ${ARCH} ubuntu:$VERSION)
    fi
    podman tag $image_id ${NAME}:${VERSION}
fi

# Run container
if [[ -z $ECHO ]]; then
    eval "podman run ${OPTS[@]}"
    podman commit $NAME-$VERSION $NAME:$VERSION
    podman rm $NAME-$VERSION
else
    echo "podman run ${OPTS[@]}"
    echo podman commit $NAME-$VERSION $NAME:$VERSION
    echo podman rm $NAME-$VERSION
fi
