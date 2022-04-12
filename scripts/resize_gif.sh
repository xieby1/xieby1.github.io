#!/usr/bin/env bash

if [[ $# -eq 0 ||  $1 == "-h" || $1 == "--help" ]]
then
    echo "gif<=10M"
    echo "Usage:"
    echo "  ${0##*/} <xxx.gif>"
    echo
    echo "Compress <xxx.gif> under and near 10M"
    echo "output to <xxx.resized.gif>"
    exit 0
fi

# functions
get_pic_size()
{
    du "$1" | sed -n 's/\([0-9]*\).*/\1/p'
}

get_pic_width()
{
    identify "$1" | sed -n '1s/\S*\s\S*\s\([0-9]*\)x[0-9]*.*/\1/p'
}

get_pic_height()
{
    identify "$1" | sed -n '1s/\S*\s\S*\s[0-9]*x\([0-9]*\).*/\1/p'
}

# constants
VERBOSE=1
PIC_ORIG=$1
PIC_RESZ=${PIC_ORIG%.*}.resized.${PIC_ORIG##*.}
TEMP_DIR=${HOME}/.miao_temp
PIC_TEMP=${TEMP_DIR}/${PIC_RESZ##*/}
PIC_SIZE_LIMIT=9600
PIC_ORIG_SIZE=$(get_pic_size "$PIC_ORIG")
PIC_ORIG_WIDTH=$(get_pic_width "$PIC_ORIG")
PIC_ORIG_HEIGHT=$(get_pic_height "$PIC_ORIG")
# variables
PIC_RESZ_SIZE=$PIC_ORIG_SIZE
PIC_RESZ_WIDTH=$PIC_ORIG_WIDTH

#echo size $PIC_RESZ_SIZE width $PIC_RESZ_WIDTH

mkdir -p ${TEMP_DIR}

while [[ $PIC_RESZ_SIZE -gt $PIC_SIZE_LIMIT ]]
do
    BC="sqrt(0.9*$PIC_RESZ_WIDTH*$PIC_RESZ_WIDTH*$PIC_SIZE_LIMIT/$PIC_RESZ_SIZE)"
    PIC_RESZ_WIDTH=$(echo $BC | bc)
    convert $PIC_ORIG -resize ${PIC_RESZ_WIDTH}x${PIC_ORIG_HEIGHT} $PIC_TEMP
    PIC_RESZ_SIZE=$(get_pic_size $PIC_TEMP)
    PIC_RESZ_WIDTH=$(get_pic_width $PIC_TEMP)
#    echo size $PIC_RESZ_SIZE width $PIC_RESZ_WIDTH
done

mv $PIC_TEMP $PIC_RESZ
rm -rf ${TEMP_DIR}
