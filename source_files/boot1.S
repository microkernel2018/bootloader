.code16
xor %ax,%ax
ljmp $0x0000,$boot

.extern boot_main

.global boot
boot:
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

movl $0xb8000,%edx
movl $hello,%ebx

boot2.loop:
  movb (%ebx),%al
  orb %al,%al
  jz boot2.done
  movb $0x3,%ah
  movl %eax,(%edx)
  add $1,%ebx
  add $2,%edx
  jmp boot2.loop

boot2.done:

.equ boot_stack_top, 0x90000
  mov $boot_stack_top,%esp
  jmp boot_main

loop_forever:
  jmp loop_forever

  cli
  hlt

hello: .ascii "Hello world!\0"
