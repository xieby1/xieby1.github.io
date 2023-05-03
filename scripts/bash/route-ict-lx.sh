#!/usr/bin/env bash
sudo route add -net 172.17.103.0 netmask 255.255.255.0 gw 10.90.50.254 metric 300 dev enp3s0
sudo route add -net 10.25.1.0 netmask 255.255.255.0 gw 10.90.50.254 metric 300 dev enp3s0
