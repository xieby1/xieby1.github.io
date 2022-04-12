#!/usr/bin/env bash

if [[ $1 == "-h" ]]
then
    echo "format xml"
    exit
fi

NAME=$1
ORIGINAL="$1.svg"
FORMATTED="$1-formatted.svg"
xmllint --format $ORIGINAL > $FORMATTED
