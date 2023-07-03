#!/bin/bash

if [ -d /sys/firmware/devicetree ]
then
	dtc -I fs /sys/firmware/devicetree/base/ -qqq -H both -@ | grep max-link
else
	echo "Devicetree not supported on this system, this script might not be useful for you"
fi

echo "check PCI link speeds with this command:"
echo "lspci -v -v 2>/dev/null | grep -E '^[0-9]|LnkCap'"
