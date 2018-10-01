ENTRY(boot)
OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x800;

	.text BLOCK(0x800) : ALIGN(0x800) {
		*(.sector0)
		*(.text)
	}

  .cd_boot1 : {
    ./object_files/cd_boot1.o(*text)
  }

  .boot_sig : AT(0x7dfe) { SHORT(0xaa55) }

  .boot2 : {
    ./object_files/boot2.o(*text)
    ./object_files/boot2.o(*rodata)
    ./object_files/boot2.o(*data)
    ./object_files/boot2.o(*bss)
  }
    /DISCARD/ : {
      *(.eh_frame)
    }

  .padding : AT(0x7ffe) { SHORT(0x0000) }

}