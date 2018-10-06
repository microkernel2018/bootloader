.code16

.extern boot_main

xor %ax,%ax
ljmp $0x0000,$boot

################################################
.section .sector0
.global _start

.code16

_start:
	# Jump past the Boot Info Table.
	# Note: We don't use the "boot" label, since addresses understood
	# by the linker start from 0x0800, while we have been loaded to 0x7C00
	# and will relocate to 0x0800 later.
	ljmp $0x0000, $0x7C40

	.skip 8 - (. - _start), 0x00

bootinfo:
	.long 0        # LBA of PVD.
	.long 0        # LBA of boot file.
	.long 0        # Length of boot file.
	.long 0        # Checksum of boot file.
	.skip 40, 0x00 # Reserved.

boot:
	# Clear interrupts and direction.
	cli
	cld

	# Set stack to 0x1000:0x0000. Pushing a word to it will cause it
	# to wrap up to 0x1000:0xFFFE.
	movw $0x1000, %ax
	movw %ax, %ss
	xorw %sp, %sp

	#Relocate (2048 bytes) from 0x0000:0x7C00 to 0x0000:0x0800.
	xorw %ax, %ax
	movw %ax, %ds
	movw $0x7C00, %si

	movw %ax, %es
	movw $0x0800, %di

	movw $2048, %cx

	rep movsb

	# Jump to bootx
	ljmp $0x0000, $bootx


################################################

bootx:
    mov %dl,disk
    cli
    movw $0x9000,%ax
    movw %ax,%ss
    movw %ax,%sp
    movw %ax,%bp
    sti

    movb $0x02,%ah           # load second stage to memory
    movb $12,%al             # numbers of sectors to read into memory
    movb disk,%dl            # sector read from fixed/usb disk ;0 for floppy; 0x80 for hd
    movb $0,%ch              # cylinder number
    movb $0,%dh              # head number
    movb $2,%cl              # sector number
    movw $0x7e00,%bx         # load into es:bx segment :offset of buffer
    int $0x13                # disk I/O interrupt

    movw $0x2401,%ax
    int $0x15 # enable A20 bit
    movw $0x3,%ax
    int $0x10 # set vga text mode 3

    cli

    lgdt gdt_pointer
    mov %cr0, %eax
    or $0x1,%eax # set the protected mode bit on special CPU reg cr0
    mov %eax, %cr0
    ljmp $0x8,$boot2 # long jump to the code segment


gdt_start:
    .quad 0x0
gdt_code:
    .word 0xFFFF
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0
gdt_data:
    .word 0xFFFF
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0
gdt_end:


gdt_pointer:
  .word gdt_end - gdt_start
  .long gdt_start

disk: .byte 0x0
.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start

.code32
boot2:
    mov $DATA_SEG, %ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
    mov %ax,%ss

boot2.done:
	.equ boot_stack_top, 0x90000
  mov $boot_stack_top,%esp
  jmp boot_main

  cli
  hlt
