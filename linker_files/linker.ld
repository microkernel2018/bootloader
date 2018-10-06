ENTRY(boot)
OUTPUT_FORMAT("binary")

SECTIONS {
    . = 0x7c00;

    .boot1 : {
        ./object_files/boot1.o(*text)
    }

    .boot_sig : AT(0x7dfe) { SHORT(0xaa55) }

    . = 0x7e00;
    .boot2 : AT(0x7e00){
        ./object_files/boot2.o(*text)
        ./object_files/boot2.o(*rodata)
        ./object_files/boot2.o(*data)
        ./object_files/boot2.o(*bss)
    }

    .padding : AT(0x7ffe) { SHORT(0x0000) }

    /DISCARD/ : {
        *(.eh_frame)
    }
}
