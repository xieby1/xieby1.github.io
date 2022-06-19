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


if [[ "$1" == "kdeconnect.app" ]]
then
    WID=$(xdotool search --classname "$1")
else
    WID=$(xdotool search --onlyvisible --name "$1")
fi

if [[ -z ${WID} ]]
then
    eval "${@:2}"
else
    for WIN in $WID
    do
        xdotool set_desktop_for_window ${WIN} $(xdotool get_desktop)
        xdotool windowactivate ${WIN}
    done
fi
