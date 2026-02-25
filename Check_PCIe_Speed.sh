#!/bin/bash

if [ -d /sys/firmware/devicetree ]
then
	maxspeed=$(dtc -I fs /sys/firmware/devicetree/base/ -qqq -H both -@ | awk '/max-link-speed/ { gsub(/[^0-9]/, "", $0); print; }' )
	maxspeed=${maxspeed//0/}
	case $maxspeed in
		1) maxspeed="Gen1"
			;;
		2) maxspeed="Gen2"
			;;
		3) maxspeed="Gen3"
			;;
		*) maxspeed="unknown speed"
			;;
	esac

	echo -e "Max PCIe speed configured via DeviceTree for: ${maxspeed}\n"
fi

for DEV in $(lspci | grep Ethernet | awk '{print $1}')
do 
        PCIeCap=$(lspci -vvv -s ${DEV} 2>&1| grep -E "LnkSta.*Width")
        PCIeName=$(lspci -vvv -s ${DEV} 2>&1 | grep -E "Product Name|Subsystem" | cut -f2- -d: | sort -u | head -1)

        Width=${PCIeCap##*, Width x}
        Width=${Width//[^0-9]/}
        # echo "Width=$Width"

        Speed=${PCIeCap##*Speed }
        Speed=${Speed%%GT/s*}
        #echo "Speed=$Speed"

        # full speed:
        #  LnkSta: Speed 5GT/s (downgraded), Width x4

        if [ "${Speed//./}" = "${Speed}" ]
        then
                TSpeed=$((Speed * 10))
        else
                TSpeed=${Speed//./}
        fi

        echo "${PCIeName}:"
        if [ ${Width:-0} -eq 4 -a ${TSpeed:-1} -gt 40 ]
        then
                echo "    PCIe dev ${DEV} at full width: ${Speed} GT/s, ${Width}x"

        elif [ ${TSpeed:-1} -gt 20 -o ${Width:-0} -lt 4 ]
        then
                echo "    PCIe dev ${DEV} at degraded speed/width: ${Speed} GT/s, ${Width}x"
        else
                echo "    PCIe dev ${DEV} at minimum speed/width: ${Speed} GT/s, ${Width}x"
        fi
done
