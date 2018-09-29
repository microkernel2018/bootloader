# disable default rules
.SUFFIXES:

.PHONY: run
.DEFAULT: run
run: bootloader_files/bootloader.bin
	qemu-system-x86_64 -drive file=$<,media=disk,format=raw -no-reboot

OBJS:=object_files/boot1.o object_files/boot2.o
CPPFLAGS:=-Wall -Wextra

object_files/boot1.o: source_files/boot1.asm
	nasm -f elf $< -o $@

object_files/boot2.o: source_files/boot2.c
	i686-elf-gcc -m32 -c $< -o $@ -e boot_main -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib $(CPPFLAGS)

bootloader_files/bootloader.bin: $(OBJS)
	i686-elf-ld $(OBJS) -o $@ -T linker_files/linker.ld
