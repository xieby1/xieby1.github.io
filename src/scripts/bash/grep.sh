#!/usr/bin/env bash

if [[ $1 == "-h" ]]
then
    echo "my grep"
    exit
fi

EXTRA_OPTION=(
    --color=always
    --line-number
)

EXCLUDE_BASIC=(
    -I
    --exclude="*.html"
    --exclude="*.js"
    --exclude="*.svg"
    --exclude="*.obj"
    --exclude="*.json"
    --exclude="*.drawio"
    --exclude="*.xml"
    --exclude="*.css"
    --exclude="*.csv"
    --exclude="tags"
    --exclude-dir="expm"
    --exclude-dir=".git"
    --exclude-dir=".stversions"
)

grep "$1" . -r \
    ${EXTRA_OPTION[@]} \
    ${EXCLUDE_BASIC[@]} \
    ${@:2}
