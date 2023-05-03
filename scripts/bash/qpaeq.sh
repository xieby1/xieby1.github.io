#!/usr/bin/env bash

pactl load-module module-equalizer-sink
pactl load-module module-dbus-protocol
qpaeq
