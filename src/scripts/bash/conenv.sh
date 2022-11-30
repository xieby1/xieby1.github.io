#!/usr/bin/env bash

# TODO: auto detect docker and podman

usage() {
    echo "Container Environment"
    echo "Usage: ${0##*/} [options] <container>"
    echo "Options:"
    echo "  -h: show this help"
    echo "  -e: echo command, without execution"
    echo "  -c: create image"
    exit 0
}

while [[ ${OPTIND} -le $# ]]
do
    getopts "lhce" opt
    case "${opt}" in
    l)
        CONTAINERS=""
        for FILE in ~/Gist/script/container/*; do
            FILE=${FILE##*/}
            CONTAINERS+="${FILE%.*} "
        done
        echo "${CONTAINERS} -h -e -c"
        exit 0
    ;;
    h)
        usage
    ;;
    c)
        CREATE=1
    ;;
    e)
        ECHO=1
    ;;
    *)
        CONTAINER=${!OPTIND}
        CONTAINERFILE=~/Gist/script/container/${CONTAINER}.*
        shift
    esac
done
if [[ -z ${CONTAINERFILE} ]]; then
    usage
fi

# DONE: sudo broken inside container
#       https://www.redhat.com/sysadmin/sudo-rootless-podman
#   tldr: not recommend use su/sudo in rootless container
# podman volumes always owned by root:
#   https://github.com/containers/podman/issues/2898
# if the first line of containerfile contains sudo
if head --lines=1 ${CONTAINERFILE} | grep sudo > /dev/null; then
    SUDO=1
fi

CMDRUN=("run")
if [[ ${SUDO} == 1 ]]; then
    CMDRUN+=("-u" "${USER}") # [root container]
else
    CMDRUN+=("--userns=keep-id") # [rootless container]
fi
CMDRUN+=(
#"-d" # deamon, not exit
"--rm" # exit then remove this container
"--env" "debian_chroot=$CONTAINER"
# "-h" "container-$CONTAINER" # host name
"-h" "localhost" # host name # avoid edit /etc/hosts
"--name=$CONTAINER" # container name

"-v" "/home/${USER}:/home/${USER}"
"-v" "/nix:/nix" # make sure symbol links in home work

"-w" "${PWD}" # working directory

# this will cause guest /etc/hosts override by host's
# use host ip instead, see host's ip address
"--network=host" # use host network stack

"-it"
"$CONTAINER"
# "/usr/bin/tmux"
)

CMDCREATE=(
"build"
"--network=host"
"--build-arg=UID=${UID}"
"--build-arg=USER=${USER}"
"-t" "${CONTAINER}"
"-f" "${CONTAINERFILE}"
"."
)

if [[ ${CREATE} == 1 ]]; then
    CMD="${CMDCREATE[@]}"
else
    CMD="${CMDRUN[@]}"
fi

# detect container backend
if command -v podman > /dev/null; then
    BACKEND=podman
elif command -v docker > /dev/null; then
    BACKEND=docker
else
    echo "Not found valid container backend"
    exit 1
fi
CMD=("${BACKEND}" "${CMD[@]}")

if [[ ${SUDO} == 1 ]]; then
    CMD=("sudo" "${CMD[@]}")
fi

if [[ ${ECHO} == 1 ]]; then
    CMD=("echo" "${CMD[@]}")
fi
eval "${CMD[@]}"
