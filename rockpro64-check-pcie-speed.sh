#!/bin/bash

dtc -I fs /sys/firmware/devicetree/base/ -qqq -H both -@ | grep max-link
