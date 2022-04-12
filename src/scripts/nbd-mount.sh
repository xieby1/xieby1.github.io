#!/usr/bin/env bash

# reference to https://askubuntu.com/questions/19430/mount-a-virtualbox-drive-image-vdi
# input: disk image to be mounted, mount destination folder

# clean should be done manually,
## sudo umount MOUNT_DIR
## sudo qemu-nbd -d /dev/nbd/nbd0p1

usage() {
    echo "nbd mount"
    echo "Usage: ${0##*/} DISK_IMAGE [-o MOUNT_DIR]"
    echo
    echo "  export DISK_IMAGE using the NBD protocol"
    echo "  mount the nbd dev to MOUNT_DIR"
    echo "  default MOUNT_DIR is c/, not create dir if c/ not exist"
    exit 0
}

if [[ $# -lt 1 ]]
then
    usage
fi

while [[ ${OPTIND} -le $# ]]; do
    getopts "ho:" opt
    case "${opt}" in
        h)
            usage
            ;;
        o)
            MOUNT_DIR=${OPTARG}
            ;;
        ?)
            DISK_IMAGE=${!OPTIND}
            shift
            ;;
        *)
            echo "unknown arg${OPTIND} ${OPTARG}"
            exit 1
            ;;
    esac
done

if [[ -z "${DISK_IMAGE}" ]]; then
    echo "DISK_IMAGE not specified"
    exit 1
fi
if [[ -z "${MOUNT_DIR}" ]]; then
    MOUNT_DIR=c
fi

# check nbd kernel module
if [[ ! -e /dev/nbd0 ]]; then
    sudo modprobe nbd max_part=16
fi
# create nbd
  # TODO: check available /dev/nbd
sudo qemu-nbd -c /dev/nbd0 ${DISK_IMAGE}
# mount
sudo mount /dev/nbd0p1 ${MOUNT_DIR}
# TODO: umount
# TODO: delete nbd
