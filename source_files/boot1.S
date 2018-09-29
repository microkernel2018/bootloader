.code16
xorw %ax,%ax
jmp $0x0000,$boot

.extern boot_main

.global boot
boot: 
    movb %dl,disk
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

    lgdt ($gdt_pointer)
    movl %cr0, %eax
    orl $0x1,%eax # set the protected mode bit on special CPU reg cr0
    movl %eax, %cr0
    jmp $CODE_SEG, $boot2 # long jump to the code segment


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
#MISMATCH: "    dw gdt_end - gdt_start"
#MISMATCH: "    dd gdt_start"

disk: .byte 0x0
.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start

.code32
boot2: 
    movw $DATA_SEG, %ax
    movw %ax,%ds
    movw %ax,%es
    movw %ax,%fs
    movw %ax,%gs
    movw %ax,%ss

    movl $hello, %esi
    movl $0xb8000,%ebx
boot2.loop: 
    lodsb
    orb %al,%al
    jz boot2.done
    orl $0x0100,%eax
    movb %al, (%ebx)
    addl $2,%ebx
    jmp boot2.loop
boot2.done: 
.equ           boot_stack_top, 0x90000
    movl $boot_stack_top, %esp
    jmp boot_main

#MISMATCH: "hello: db "Hello world!",0"

#MISMATCH: "times 510 -($-$$) db 0"
.word 0xaa55

.equ               boot_stack_bottom, $

#WARNING, Line 33: no syntax match: "    lgdt [gdt_pointer] "
#WARNING, Line 60: no syntax match: "    dw gdt_end - gdt_start"
#WARNING, Line 61: no syntax match: "    dd gdt_start"
#WARNING, Line 64: no syntax match: "CODE_SEG equ gdt_code - gdt_start"
#WARNING, Line 65: no syntax match: "DATA_SEG equ gdt_data - gdt_start"
#WARNING, Line 83: no syntax match: "    mov word [ebx], ax"
#WARNING, Line 91: no syntax match: "hello: db "Hello world!",0"
#WARNING, Line 93: no syntax match: "times 510 -($-$$) db 0"
