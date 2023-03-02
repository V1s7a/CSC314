section .data


section .bss
    BUF_SIZE equ 1024
    inputBuffer resb BUF_SIZE
    inputByteCount resd 1 

section .text

    extern _start

_start:


mimic_loop:
 
    mov eax, SYS_READ ;;set ups sys read
    mov ebx, FD_STDIN 
    mov ecx, inputBuffer 
    mov edx, BUF_SIZE
    int 0x80 ;; trigger sys_read

    mov [inputByteCount], eax ;;store byte count


    
    cmp dword [inputByteCount], 0  ;;check EOF
    jle end_mimic_loop ;;break

    mov eax, SYS_WRITE ;; setup sys_write
    mov ebx, FD_STDOUT
    mov ecx, inputBuffer 
    mov edx, [inputByteCount] 
    int 0x80 ;; trigger sys_write

    jmp mimic_loop ;;loop

end_mimic_loop:



;EXIT
    mov eax, 1
    mov ebx, 0
    int 0x80


;; define some symbols

    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2