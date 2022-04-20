#!/usr/bin/env bash
if [[ $1 == "-h" ]]
then
    echo "pdb src file"
    exit
fi
CVDUMP=~/Softwares/Packages/Kernel/Windows/tools/cvdump.exe

wine "${CVDUMP}" -sf $1
