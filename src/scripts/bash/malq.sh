#!/usr/bin/env bash
# mips as ld qemu
mipsel-linux-gnu-as -gstabs -o ${1%.*}.o $1
mipsel-linux-gnu-ld -o ${1%.*} ${1%.*}.o
/nix/store/00nnmqad2x3ssc9y2pn3kx0gh5m92bxv-qemu-7.1.0/bin/qemu-mipsel ${1%.*}
