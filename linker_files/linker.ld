ENTRY(boot)
OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x7c00;

  .boot : {
    boot2.o(*text)
  }

  .boot_sig : AT(0x7dfe) { SHORT(0xaa55) }


  . = 0x7e00;
  .kernel : AT(0x7e00){
    kernel.o(*text)
    kernel.o(*rodata)
    kernel.o(*data)
    kernel.o(*bss)
  }
    /DISCARD/ : {
      *(.eh_frame)
    }

  .padding : AT(0x7ffe) { SHORT(0x0000) }

}
