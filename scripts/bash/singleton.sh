#!/usr/bin/env bash
# based on quteapp.sh
usage()
{
    echo "Usage: ${0##*/} <window> <command and its args>"
    echo "  Only start a app once, if the app is running"
    echo "  then bring it to foreground"
    exit 0
}

if [[ $# -lt 2 || $1 == "-h" ]]
then
    usage
fi

WID=$(xdotool search --onlyvisible --name "$1")

if [[ -z ${WID} ]]
then
    eval "${@:2}"
else
    xdotool windowactivate ${WID}
fi
