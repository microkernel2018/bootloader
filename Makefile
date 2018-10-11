# disable default rules
.SUFFIXES:

.PHONY: run
.DEFAULT: run

run: clean object_files/cd_boot1.o object_files/boot1.o object_files/boot2.o object_files/enable_paging.o object_files/Kernel.o bootloader_files/cd_bootloader.bin bootloader_files/bootloader.bin iso


qemu-boot-hdd:bootloader_files/bootloader.bin
	qemu-system-x86_64 -drive file=$<,media=disk,format=raw -no-reboot

qemu-boot-cd:bootloader_files/mk2018.iso
	qemu-system-x86_64 -cdrom bootloader_files/mk2018.iso -no-reboot

OBJS:= ./object_files/boot1.o ./object_files/boot2.o ./object_files/enable_paging.o ./object_files/Kernel.o
OBJS2:=./object_files/cd_boot1.o ./object_files/boot2.o ./object_files/enable_paging.o ./object_files/Kernel.o
ISODEST ?= ./bootloader_files/mk2018.iso

CPPFLAGS:=-Wall -Wextra

clean:
	rm -rf bootloader_files
	rm -rf object_files
	mkdir bootloader_files
	mkdir object_files


object_files/boot1.o: source_files/boot1.S
	i686-elf-as $< -o $@

object_files/boot2.o: source_files/boot2.c
	i686-elf-gcc -m32 -c $< -o $@ -e boot_main -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib $(CPPFLAGS)

object_files/enable_paging.o: source_files/enable_paging.S
	i686-elf-as $< -o $@

object_files/Kernel.o: source_files/Kernel.c
	i686-elf-gcc -m32 -c $< -o $@ -e boot_main -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib $(CPPFLAGS)

bootloader_files/bootloader.bin: $(OBJS)
	i686-elf-ld $(OBJS) -o $@ -T linker_files/linker.ld

object_files/cd_boot1.o: source_files/cd_boot1.S
	i686-elf-as $< -o $@

bootloader_files/cd_bootloader.bin: $(OBJS2)
	i686-elf-ld $(OBJS2) -o $@ -T linker_files/iso_linker.ld

iso:
	xorriso -as mkisofs \
	-b bootloader_files/cd_bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
	-o $(ISODEST) .
