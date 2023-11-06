#!/usr/bin/env bash

if [[ $# -eq 0 || ($# -eq 1 && $1 == "-h") ]]; then
    echo "Popup desktop notification messages. (Default messages: $DEFAULT_MSG)"
    echo "Usage: ${0##*/} [-h] <Command and its args ...>"
    exit
fi

eval "$@"

if [[ "$TERM" =~ tmux ]]; then
    # https://github.com/tmux/tmux/issues/846
    printf '\033Ptmux;\033\x1b]99;;%s\033\x1b\\\033\\' "$*"
else
    printf '\x1b]99;;%s\x1b\\' "$*"
fi
