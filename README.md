# arm-misc
Miscellaneous things for ARM systems to make my life easier


* orangepi5plus-gpio-pwr-led.dts

  Overlay source to provide a simple driver for a single gpio-based LED,
typically used for a power or drive activity LED on a case.  Additional LEDs
can be supported by duplicating the 'pwr_led@3' section, renaming and
incrementing the serial, and then changing the label and gpio.

* rockpro64-pcie-gen2.dts

  Overlay source that will enable PCIe gen2 speeds on the Pine64 RockPro64
board.  This has been tested with an Intel 2x 10gb network card
successfully, but rumor has it that not all expansion cards will work correctly.

* orangepi5plus-pwm-fanctl.sh

  Control a GPIO-based PWM fan on the Orange Pi 5+ from the CLI.  Accepts a
duty cycle percentage as an argument (15-100) and applies the correct math
to work out the correct values based on the converting the frequency into
the period along with the duty cycle.  If there is only own PWM overlay
active, the script will automatically detect and attempt to use that.

* dtb-check-pcie-speed.sh

  Basic one-liner to pull the max supported PCIe speeds from the system DTB.
Should work on any device-tree enabled system.
