# arm-misc
Miscellaneous things for ARM systems to make my life easier

Orange PI 5+:

* orangepi5plus-gpio-drive-led.dts

  Overlay source to provide a simple driver for a single gpio-based LED,
typically used for a power or drive activity LED on a case.  Additional LEDs
can be supported by duplicating the 'drive-led' section, renaming the
section, incrementing the enumerator, and then changing the label and gpio.

* orangepi5plus-pwm-fan.dts

  Adjusts the temperature thresholds for the Opi5+ built-in fan header.

* orangepi5plus-pwm14m0.dts

  Enable pwm14 so that it can be used by userspace.  Use this to drive an
external PWM-modulated fan, along with the script below.

* orangepi5plus-pwm-fanctl.sh

  Control a GPIO-based PWM fan on the Orange Pi 5+ from the CLI.  Accepts a
duty cycle percentage as an argument (15-100) and applies the correct math
to work out the correct values based on the converting the frequency into
the period along with the duty cycle.  If there is only own PWM overlay
active, the script will automatically detect and attempt to use that.


RockPro64:

* rockpro64-pcie-gen2.dts

  Overlay source that will enable PCIe gen2 speeds on the Pine64 RockPro64
board.  This has been tested with an Intel 2x 10gb network card
successfully, but rumor has it that not all expansion cards will work correctly.

* dtb-check-pcie-speed.sh

  Basic one-liner to pull the max supported PCIe speeds from the system DTB.
Should work on any device-tree enabled system.

* rockpro64-gpio-misc-fan.dts

  Provides kernel control of a simple on/off GPIO-triggered fan on the RockPro64
defaulting to the temperature map 'cpu-high' but changable via CLI or
editing the overlay source.   Multiple fans can be defined, following the
notes in the source.

* rockpro64-gpio-misc-led.dts

  Overlay source to provide a simple driver for a single gpio-based LED,
typically used for a power or drive activity LED on a case.  Additional LEDs
can be supported by duplicating the apropriate section, renaming the
section, incrementing the enumerator, and then changing the label and gpio.
