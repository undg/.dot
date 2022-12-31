#!/bin/bash
echo -e "----------------------------------------------------------------------------"
echo -e "basename\tpowercontrol\tspeed\tproduct"
echo -e "----------------------------------------------------------------------------"
for d in /sys/bus/usb/devices/[0-9]*
    do if [[ -e $d/product ]]; then
	echo -e "`basename $d`\t\t`cat $d/power/control`\t\t`cat $d/speed`\t`cat $d/product`"
    fi
    done
