# bootloader
This project is intended to be a GRUB like multi-boot bootloader. Currently it does not support multi-boot. At this point it is a two stage bootloader. The second stage loads after switching on to Protected mode. The goal here is to enable the bootloader to read multi-boot headers. This version was compiled with a cross-compiler with no specific OS toolchain.
