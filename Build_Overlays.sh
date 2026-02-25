#!/bin/bash

if [ -e /sys/firmware/devicetree/base/model ]
then
	model=$(strings /sys/firmware/devicetree/base/model)
elif [ -e /proc/device-tree/model ]
then
	model=$(strings /proc/device-tree/model)
else
	model=$(grep -iE 'rockpro|Orange.*pi.*5.*(plus|\+)' /proc/cpuinfo )
fi

if [ -n "$1" ]
then
	model=$1
elif [ -z "${model}${1}" ]
then
	echo "Can't determine model, exiting"
	exit 1
fi

model=${model,,}

if [ -z "${model##*rockpro*}" ];
then
	echo "Detected RockPro64"
	prefix="rockpro64"

elif [ -z "${model##*orange*}" ];
then
	echo "Detected Orange Pi 5+"
	prefix="orangepi5plus"
else
	echo "Unknown platform: $model"
	exit 1
fi


for file in  $(ls -1 ${prefix}-*.dts)
do
	CMD=$(grep -i dtc ${file} )
	CMD=${CMD//*dtc/dtc}
	
	eval "${CMD}"
done
