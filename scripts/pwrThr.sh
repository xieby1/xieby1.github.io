#!/usr/bin/env bash

# Toggle Lenovo Power Threshold
# References
#  https://askubuntu.com/questions/1038471/problem-with-lenovo-battery-threshold
if [[ $1 == "-h" ]]
then
    echo "toggle pwrThr"
    exit
fi

INTERFACE="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
THRSTATE=$(cat "${INTERFACE}")

# redirection is done by shell, so `sudo echo XXX >> XXX` is not work
# refers to: https://askubuntu.com/questions/230476/how-to-solve-permission-denied-when-using-sudo-with-redirection-in-bash
sudo bash -c "echo $((! THRSTATE)) > ${INTERFACE}"

echo "Power Threshold $THRSTATE => $((! THRSTATE))"
