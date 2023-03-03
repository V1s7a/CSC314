section .data


section .bss
    BUF_SIZE equ 1024          ;; size of input buffer
    inputBuffer resb BUF_SIZE  ;; input buffer
    inputByteCount resd 1 

    outputBuffer resb BUF_SIZE ;; defines an output buffer, same size as input buffer

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

    ;; ESI is input character position
    mov esi, [inputByteCount] ;;using esi for character postion
    sub esi, 2 ;; starting input character position at inputByteCount-1 (last character before the newline)
    mov edi, 0 ;; EDI will be the output character position, starts at 0 and goes up


reverse_buffer_loop:
    ;;the line below is ALMOST possible in NASM
    ;; unfourtunately you cannot have memory location as a source, and another memory location as destination
    ;;mov  [outputBuffer+edi], [inputBuffer+esi]    ;; from address inputBuffer + charPosition to outputBuffer
    mov AL, [inputBuffer+esi] ;; copy byte into 1 byte half-half register AL
    mov [outputBuffer+edi], AL ;; copy byte in AL to the address in the outputbuffer it needs to go

    inc edi ;; increment the output (reverse) buffer offset (character position) counting up from 0
    dec esi ;;decrement character position, counting down from the last character
    cmp esi, 0 ;;compare if last character is zero
    jl end_reverse_buffer_loop ;; jump if less than zero, can use js (jump if sign, negative)
    jmp reverse_buffer_loop

end_reverse_buffer_loop:
    ;; need to deal with newline character
    mov AL, [inputBuffer+edi]   ;; After the above loop finishes, EDI will be inputByteCount-1, the position of the newline
    mov [outputBuffer+edi], AL 

    mov eax, SYS_WRITE ;;print newline character
    mov ebx, FD_STDOUT
    mov ecx, outputBuffer
    mov edx, inputByteCount
    int 0x80 ;; trigger interrupt

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