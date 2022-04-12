#!/usr/bin/env bash
# ability to ignore some file
if [[ $1 == "-h" ]]
then
    echo "un-hidden files"
    exit
fi

find . \( ! -regex '.*/\..*' \) -type f
