#/usr/bin/env bash

# parsing arguments
VERSION=latest
while [[ ${OPTIND} -le $# ]]; do
    getopts "lhe" opt
    case "${opt}" in
    l|h)
        # echo "aarch64 riscv64 x86_64 18.04 20.04 22.04 22.10 23.04 latest -h -e"
        echo "TODO -h -e"
        exit 0
    ;;
    e)
        ECHO=1
    ;;
    *)
        arg=${!OPTIND}
        # case "$arg" in
        # aarch64|riscv64|x86_64)
        #     ARCH=$arg
        # ;;
        # *)
        #     VERSION=$arg
        # ;;
        # esac
        NAME="$arg"
        shift
    ;;
    esac
done
# NAME=ubuntu-${ARCH}

OPTS=(
    "-u root"
    # "--userns=keep-id" # [rootless container]
    # "-h" "container-$NAME" # host name
    "-h localhost" # host name # avoid edit /etc/hosts

    # "--name=$NAME-$VERSION" # container name
    "--name=my$NAME" # TODO: container name

    "-v $HOME:$HOME"
    "-v $HOME:/root"
    "-v /nix:/nix" # make sure symbol links in home work
    "-v /run/binfmt:/run/binfmt"
    "-w $PWD" # working directory

    # this will cause guest /etc/hosts override by host's
    # use host ip instead, see host's ip address
    "--network=host" # use host network stack

    "-it"
    # "$NAME:$VERSION"
    "$NAME"
    "/bin/sh"
)

# Pull image
# podman images ${NAME}:${VERSION} | grep ${NAME} &> /dev/null
podman images ${NAME} | grep ${NAME} &> /dev/null
if [[ $? != 0 ]]; then
    # image_id=$(podman pull --arch ${ARCH} ubuntu:$VERSION)
    image_id=$(podman pull ${NAME})
    # podman tag $image_id ${NAME}:${VERSION}
    podman tag $image_id ${NAME}
fi

# Run container
if [[ -z $ECHO ]]; then
    eval "podman run ${OPTS[@]}"
    # podman commit $NAME-$VERSION $NAME:$VERSION
    # podman rm $NAME-$VERSION
    podman commit my$NAME $NAME
    podman rm my$NAME
else
    echo "podman run ${OPTS[@]}"
    # echo podman commit $NAME-$VERSION $NAME:$VERSION
    # echo podman rm $NAME-$VERSION
    echo podman commit my$NAME $NAME
    echo podman rm my$NAME
fi
