#!/bin/bash
## this code snippet is taken from Dan Dascalescu's response on
## http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]
do
        # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
PDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd -P )"
ODIR=$(pwd -P)
cd ${PDIR}

#if [ -e /sys/firmware/devicetree/base/model ]
#then
#	model=$(strings /sys/firmware/devicetree/base/model)
#elif [ -e /proc/device-tree/model ]
#then
#	model=$(strings /proc/device-tree/model)
#else
#	model=$(grep -iE 'rockpro|Orange.*pi.*5.*(plus|\+)' /proc/cpuinfo )
#fi

model=$(grep -iE 'rockpro|Orange.*pi.*5.*(plus|\+)' /proc/cpuinfo || strings /proc/device-tree/model || strings /sys/firmware/devicetree/base/model)

if [ -z "${model}${1}" ]
then
	echo "Can't determine model, exiting"
	exit 1
fi
if [ -n "$1" ]
then
	model=$1
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

	if [ -n "${CMD}" ]
	then
		eval "${CMD}"
		if [ $? ]
		then
			echo "${file//.dts/} built successfully"
		else
			echo "${file//.dts/} failed to build!"
		fi
	else
		echo "${file//.dts/} skipped"
	fi
done

cd "${ODIR}"
