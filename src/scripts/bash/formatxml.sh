#!/usr/bin/env bash

if [[ $1 == "-h" ]]
then
    echo "${0##*/} <xml_file>"
    echo "  Format xml file in place."
    echo "  If the file extension is .drawio,"
    echo "  this script will try to uncompress it first."
    exit
fi

IN=$1
BAK=${1%.*}.bak.${1##*.}
mv "$IN" "$BAK"
if [[ "${IN##*.}" == "drawio" ]]
then
    drawio -u -x -f xml "$BAK" &> /dev/null
    xmllint --format "${BAK%.*}.xml" > "$IN"
    rm -f "${BAK%.*}.xml"
else
    xmllint --format "$BAK" > "$IN"
fi
mv "$BAK" "/tmp/${IN##*/}"
