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

model=$(grep -iE 'rockpro|Orange' /proc/cpuinfo || strings /proc/device-tree/model || strings /sys/firmware/devicetree/base/model)

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
elif [ -z "${model##*orange pi 4 pro*}" ];
then
	echo "Detected Orange Pi 4 Pro"
	prefix="orangepi4pro"
elif [ -z "${model##*orange pi 5 plus*}" ];
then
	echo "Detected Orange Pi 5+"
	prefix="orangepi5plus"
else
	echo "Unknown platform: $model"
	exit 1
fi


for file in  $(ls -1 ${prefix}-*.dts 2>/dev/null)
do
	CMD=$(grep -i dtc ${file} )
	CMD=${CMD//*dtc/dtc}

	if [ -n "${CMD}" ]
	then
		eval "${CMD}"
		if [[ $? -eq 0 ]]
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
