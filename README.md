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
