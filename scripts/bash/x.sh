#!/usr/bin/env bash
xdotool type --delay 30 "$(cd ~/Gist/script/bash/ && ls --color=never x-* | rofi -dmenu | xargs bash -c)"
