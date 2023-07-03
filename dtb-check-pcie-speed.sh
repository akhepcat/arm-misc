#!/bin/bash

dtc -I fs /sys/firmware/devicetree/base/ -qqq -H both -@ | grep max-link

echo "check PCI link speeds with this command:"
echo "lspci -v -v 2>/dev/null | grep -E '^[0-9]|LnkCap'"
