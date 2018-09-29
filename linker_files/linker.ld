ENTRY(boot)
OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x7c00;
  .boot :
  {
    *(.boot)
  }

  .kernel : AT(0x7e00)  /* place immediately after the boot sector */
  {
    *(.text)
    *(.rodata)
    *(.data)
    _bss_start = .;
    *(.bss)
    *(COMMON)
    _bss_end = .;
  }
  kernel_sectors = (SIZEOF(.kernel) + 511) / 512;

  /DISCARD/ : {
        *(.eh_frame)
  }

  .padding : AT(0x81fe) {
    SHORT(0x0000)
  }
}
