#!/bin/sh
nasm -f elf32 ./source_files/boot1.asm -o ./object_files/boot1.o
i686-elf-gcc -m32 -c ./source_files/boot2.c -o ./object_files/boot2.o -e boot_main -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib  -Wall -Wextra
i686-elf-ld ./object_files/boot1.o ./object_files/boot2.o -o ./bootloader_files/bootloader.bin -T ./linker_files/linker.ld
qemu-system-x86_64 ./bootloader_files/bootloader.bin
