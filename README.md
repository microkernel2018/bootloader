# bootloader


<pre>
$ make                    # Clean all the output files and re-build them.
$ make qemu-boot-hdd      # Boot qemu from the hard-disk drive (bootlader.bin).
$ make qemu-boot-cd       # Boot qemu from the CDROM drive (mk2018.iso).
</pre>

## Dependencies

* You will need an i686 GCC and binutils toolchain. The osdev-toolchains repo builds this.
* You will also need xorriso to build the CD image.

## Code origin

* The code-chunk for converting the executable binary file into ISO image was taken from the proposal-template repo.
*<a href="https://github.com/microkernel2018/proposal-template">Proposal-Template<a> 
