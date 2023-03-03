section .data


section .bss
    BUF_SIZE equ 1024
    inputBuffer resb BUF_SIZE
    inputByteCount resd 1 

section .text

    extern _start

_start:


reverse_loop:
 
    mov eax, SYS_READ ;;set ups sys read
    mov ebx, FD_STDIN 
    mov ecx, inputBuffer 
    mov edx, BUF_SIZE
    int 0x80 ;; trigger sys_read

    mov [inputByteCount], eax ;;store byte count


    
    cmp dword [inputByteCount], 0  ;;check EOF
    jle end_reverse_loop ;;break

    ;;the first character to print is the last character read, except the newline character
    ;;so its position will be inputByteCount-2 (the newline will be at inputByteCount-1)

    mov esi, [inputByteCount] ;;using esi for character postion
    sub esi, 2 ;; starting character position at inputByteCount-1 (last character before the newline)


single_char_loop:
    ;; strategy A: a loop to print one character at a time
    mov eax, SYS_WRITE ;; setup sys_write
    mov ebx, FD_STDOUT
    mov ecx, inputBuffer ;; want inputBuffer plus character position
    add ecx, esi         ;; add the characterPostion to the start address of inputBuffer
    mov edx, 1           ;;we only want to print one character at a time
    int 0x80 ;; trigger sys_write

    dec esi ;;decrement character position
    cmp esi, 0 ;;compare if last character is zero
    jl end_single_char_loop ;; jump if less than zero, can use js (jump if sign, negative)
    jmp single_char_loop

end_single_char_loop:

    jmp reverse_loop ;;loop

end_reverse_loop:
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