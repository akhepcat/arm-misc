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

envf=$(find /boot -maxdepth 1 -iname 'armbianEnv.txt' -o -iname 'orangepiEnv.txt')
if [ -z "${PWMCHIP}" ]
then
	PWMS="$(grep -oE 'pwm[0-9]+-m[0-9]+' ${envf:-/dev/null})"	# "pwm14-m0"
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
		pwm3)	IOADDR=fd8b0030;;
		pwm10)  IOADDR=febe0020;;
		pwm11)  IOADDR=febe0030;;
		pwm12)  IOADDR=febf0000;;
		pwm13)  IOADDR=febf0010;;
		pwm13)  IOADDR=febf0010;;
		pwm14)  IOADDR=febf0020;;
		pwm15)  IOADDR=febf0030;;
		*) echo "unknown PWM chip, can't determine IOADDR for disambiguation in /sys/class/pwm"; exit 1;;
	esac

	PWMCHIP=$(/bin/ls -l /sys/class/pwm/ | grep ${IOADDR} | grep -owE 'pwmchip[0-9]' | head -1)
	PWMPORT=${PWMS#*-m}
fi

FREQ=$(echo "scale = 5; print ( ( 1 / ${FREQ} ) * 1000000000 ); print \"\n\";"  | bc)
FREQ=${FREQ/.*}

DUTYCYCLE=$(echo "scale = 5; print ( ${FREQ} - (${FREQ} * (${DUTYCYCLE}/100) )); print \"\n\";"  | bc)
DUTYCYCLE=${DUTYCYCLE/.*}

# Make sure the pwm chip is available
if [ -e /sys/class/pwm/${PWMCHIP}/export ]
then
	if [ ! -d /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT} ]
	then
		echo ${PWMPORT} > /sys/class/pwm/${PWMCHIP}/export
	fi
	if [ -d /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/ ]
	then
		echo $FREQ > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/period
		echo $DUTYCYCLE > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/duty_cycle

		# enable it if it wasn't already
		echo 1 > /sys/class/pwm/${PWMCHIP}/pwm${PWMPORT}/enable
		exit 0
	fi
fi
echo "pwm support not enabled, fan management disabled"
