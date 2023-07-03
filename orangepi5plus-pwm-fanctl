#!/bin/bash
#

PWMCHIP=""			# blank to use autoselect (only enable 1 pwm overlay) otherwise 
PWMPORT=""			# put the chip (pwmchip0) and port (0) here

DUTYCYCLE=${1:-50}		# percent duty cycle on the command line
FREQ=25000			# in hertz (based on the fan requirements)

if [ $DUTYCYCLE -lt 15 ]
then
	DUTYCYCLE=15
fi

# ------------

if [ -z "${PWMCHIP}" ]
then
	PWMS="$(grep -oE 'pwm\S+' /boot/orangepiEnv.txt)"	# "pwm14-m0"
	PWMA=($PWMS)
	pc=${#PWMA[@]} 
	if [ ${pc} -gt 1 ]
	then
		echo "can't autodetect fan from multiple PWM enabled ports, manually set in script"
		exit 1
	fi

	case ${PWMS%-*} in
		pwm0)	IOADDR=fd8b0000;;
		pwm1)	IOADDR=fd8b0010;;
		pwm10)  IOADDR=febe0020;;
		pwm11)  IOADDR=febe0030;;
		pwm12)  IOADDR=febf0000;;
		pwm13)  IOADDR=febf0010;;
		pwm14)  IOADDR=febf0020;;
		*) echo "unknown PWM chip, can't determine IOADDR for disambiguation in /sys/class/pwm"; exit 1;;
	esac

	PWMCHIP=$(/bin/ls -l /sys/class/pwm/ | grep ${IOADDR} | grep -owE 'pwmchip[0-9]' | head -1)
	PWMPORT=${PWMS#*-m}
fi

#PWMCHIP=pwmchip2		# PWM14_M0, which is pwm chip 2; there's only 1 pwm channel (pwm0) available on chip 2
#PWMPORT=0

FREQ=$(echo "scale = 5; print ( ( 1 / ${FREQ} ) * 1000000000 ); print \"\n\";"  | bc)
FREQ=${FREQ/.*}

DUTYCYCLE=$(echo "scale = 5; print ( ${FREQ} - (${FREQ} * (${DUTYCYCLE}/100) )); print \"\n\";"  | bc)
DUTYCYCLE=${DUTYCYCLE/.*}

# Make sure the pwm chip is available
[[ ! -d /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT} ]] && \
	echo ${PWMPORT} > /sys/class/pwm/${PWMCHIP}/export

echo $FREQ > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/period
echo $DUTYCYCLE > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/duty_cycle

# enable it if it wasn't already
echo 1 > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/enable
