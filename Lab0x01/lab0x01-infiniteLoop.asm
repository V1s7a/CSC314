global _start ;define symbol for linker

section .data
    msg db "Infinite Message", 10 ; define message
    msgLen equ $ - msg ;get length of msg and set the number of bytes to symbol msgLen

section .text
_start:
    ;set registers
    mov eax, 4; call write on interrupt
    mov ebx, 1; use stdout on interrupt
    mov ecx, msg ;set address to array of bytes
    mov edx, msgLen ;set register to the number of bytes in msg array
    int 0x80 ; invoke interrupt
    jmp _start ;restart the program infinitely by jumping back to start
