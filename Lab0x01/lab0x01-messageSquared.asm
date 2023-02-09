global _start ; define symbol for linker

section .data
    msg db "This message.", 10
    len equ $ - msg

section .text

_start: ; define program start
    mov cx, $x ; establish memory in register that can be incremented cx counter registry
    loop: ; define new label to loop
        mov eax, 4; call write on interrupt
        mov ebx, 1; set stdout
        mov ecx, msg ; set register ecx to address of message
        mov edx, len ; set register edx to number of bits to be printed on interrupt
        int 0x80 ;invoke interrupt
        inc cx ; increment the eax register by 1
        cmp cx, 13 ; compare counter registry to the number 13
        jne loop ; conditionally jump to label loop
        mov $s, cx 

    ; exit program
    mov eax, 1 ; copy 1 to register eax, 1 is used to sys_exit() on interrupt
    mov ebx, 0 ; return 0 for program return code - program completion successful
    int 0x80 ; invoke interrupt


