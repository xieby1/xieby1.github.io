#!/usr/bin/env bash

usage()
{
    echo "Usage: ${0##*/} <window> <url>"
    exit 0
}

if [[ $# -lt 2 || $1 == "-h" ]]
then
    usage
fi

WID=$(xdotool search --onlyvisible --name "${1}.*qutebrowser")
URL=$2

if [[ -z ${WID} ]]
then
    qutebrowser "$URL"
else
    xdotool set_desktop_for_window ${WID} $(xdotool get_desktop)
    xdotool windowactivate ${WID}
fi
