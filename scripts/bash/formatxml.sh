#!/usr/bin/env bash

if [[ $1 == "-h" ]]
then
    echo "format xml"
    exit
fi

IN=$1
BAK=${1%.*}.bak.${1##*.}
mv "$IN" "$BAK"
xmllint --format "$BAK" > "$IN"
mv "$BAK" "/tmp/${IN##*/}"
