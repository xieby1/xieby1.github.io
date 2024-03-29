#!/bin/bash
# By Chih-Wei Huang <cwhuang@linux.org.tw>
# License: GNU Generic Public License v2

continue_or_stop()
{
        echo "Please Enter to continue or Ctrl-C to stop."
        read
}

QEMU_ARCH=`uname -m`
QEMU=qemu-system-${QEMU_ARCH}

which $QEMU > /dev/null 2>&1 || QEMU=qemu-system-i386
if ! which $QEMU > /dev/null 2>&1; then
        echo -e "Please install $QEMU to run the program.\n"
        exit 1
fi

cd ${OUT:-ANDROID_ROOT}

[ -e system.img ] && SYSTEMIMG=system.img || SYSTEMIMG=system.sfs

if [ -d data ]; then
        if [ `id -u` -eq 0 ]; then
                DATA="-virtfs local,id=data,path=data,security_model=passthrough,mount_tag=data"
                DATADEV='DATA=9p'
        else
                echo -e "\n$(realpath data) subfolder exists.\nIf you want to save data to it, run $0 as root:\n\n$ sudo $0\n"
                continue_or_stop
        fi
elif [ -e data.img ]; then
        if [ -w data.img ]; then
                DATA="-drive index=2,if=virtio,id=data,file=data.img"
                DATADEV='DATA=vdc'
        else
                echo -e "\n$(realpath data.img) exists but is not writable.\nPlease grant the write permission if you want to save data to it.\n"
                continue_or_stop
        fi
fi

run_qemu_on_port()
{
        $QEMU -enable-kvm \
        -kernel kernel \
        -append "CMDLINE console=ttyS0 RAMDISK=vdb $DATADEV" \
        -initrd initrd.img \
        -m 2048 -smp 2 -cpu host \
        -usb -device usb-tablet,bus=usb-bus.0 \
        -machine vmport=off \
        -soundhw ac97 \
        -serial mon:stdio \
        -boot menu=on \
        -drive index=0,if=virtio,id=system,file=$SYSTEMIMG,format=raw,readonly \
        -drive index=1,if=virtio,id=ramdisk,file=ramdisk.img,format=raw,readonly \
        -netdev user,id=mynet,hostfwd=tcp::$port-:5555 -device virtio-net-pci,netdev=mynet \
        $DATA $@
}

run_qemu()
{
        port=5555
        while [ $port -lt 5600 ]; do
                run_qemu_on_port $@ && break
                let port++
        done
}

# Try to run QEMU in several VGA modes
run_qemu -vga virtio -display sdl,gl=on $@ || \
run_qemu -vga qxl -display sdl $@ || \
run_qemu -vga std -display sdl $@ || \
run_qemu $@
