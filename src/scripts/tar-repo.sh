#!/usr/bin/env bash

usage()
{
    echo "tar git files"
    echo "${0##*/} [-h] <DIR>"
    echo "tar git repo <DIR>, exclude patterns from"
    echo "  * global gitignore"
    echo "  * repo's gitignore"
    echo "  * repo's git/info/exclude"
    echo "output to DIR.tar.gz"
    exit 0
}

if [[ $# -lt 1 ]]
then
    usage
fi
if [[ $1 == "-h" ]]
then
    usage
fi

GI=~/Documents/Config/ignore/git
RI="$1/.gitignore"
RE="$1/.git/info/exclude"

tar \
    -X "${GI}" \
    -X "${RI}" \
    -X "${RE}" \
    -czf "${1%/}.tar.gz" \
    "$1"

