bits 16
xor ax,ax
jmp 0x0000:boot

extern boot_main

global boot
boot:
    mov [disk],dl
    cli
    mov ax,0x9000
    mov ss,ax
    mov sp,ax
    mov bp,ax
    sti

    mov ah, 0x02             ; load second stage to memory
    mov al, 12               ; numbers of sectors to read into memory
    mov dl, [disk]           ; sector read from fixed/usb disk ;0 for floppy; 0x80 for hd
    mov ch, 0                ; cylinder number
    mov dh, 0                ; head number
    mov cl, 2                ; sector number
    mov bx, 0x7e00           ; load into es:bx segment :offset of buffer
    int 0x13                 ; disk I/O interrupt

    mov ax, 0x2401
    int 0x15 ; enable A20 bit
    mov ax, 0x3
    int 0x10 ; set vga text mode 3

    cli

    lgdt [gdt_pointer] ; load the gdt table
    mov eax, cr0
    or eax,0x1 ; set the protected mode bit on special CPU reg cr0
    mov cr0, eax
    jmp CODE_SEG:boot2 ; long jump to the code segment


gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:


gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start

disk: db 0x0
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esi,hello
    mov ebx,0xb8000
.loop:
    lodsb
    or al,al
    jz .done
    or eax,0x0100
    mov word [ebx], ax
    add ebx,2
    jmp .loop
.done:
boot_stack_top equ 0x90000
    mov esp, boot_stack_top
    jmp boot_main

hello: db "Hello world!",0

times 510 -($-$$) db 0
dw 0xaa55

boot_stack_bottom: equ $
