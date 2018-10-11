# bootloader


<pre>
$ make                    # Clean all the output files and re-build them.
$ make qemu-boot-hdd      # Boot qemu from the hard-disk drive (bootloader.bin).
$ make qemu-boot-cd       # Boot qemu from the CDROM drive (mk2018.iso).
</pre>

## Dependencies

* You will need an i686 GCC and binutils toolchain. The
  [osdev-toolchains](https://github.com/microkernel2018/osdev-toolchains) repo
  builds this.
* You will also need xorriso to build the CD image.
