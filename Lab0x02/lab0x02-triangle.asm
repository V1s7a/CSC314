section .data
    msgA db "Please enter a single character to make a triangle:", 0x0A ;;startup message
    msgALen equ $-msgA ;; calculate length of msgA
    error_msg db "Error: entered more than one character!" ;;error message
    msgErrorLen equ $-error_msg ;; calculate length of error_msg
    success_msg db "Here is your triangle", 0x0A ;; success message
    msgSuccessLen equ $-success_msg
    ;;msgALen equ 52
    ;;msgErrorLen equ 39
    ;;msgSuccessLen equ 22
    LetterA db "A"
    lenLetterA equ 1

section .bss
    LINES equ 42 ;; set the number of lines to print to 42
    char_buff resb 2;; set one byte for character buffer
    inputCharCount resd 1 ;; allocate space to store number of characters for input
    line_counter resb 4 ;; allocate 4 bytes to line counter
    char_counter resb 4 ;; allocate 4 bytes to char counter

section .text
    extern _start

_start:
    ;; Print prompt
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, msgA
    mov edx, msgALen
    int 0x80 ;; trigger sys_interrupt


    ;;read char
    mov eax, SYS_READ ;;set ups sys read
    mov ebx, FD_STDIN 
    mov ecx, char_buff 
    mov edx, 1024
    int 0x80 ;; trigger sys_read

    mov [inputCharCount], eax ;; move number of characters from input into variable

    ;;check for more than one character
    cmp eax, 2 ;; compare if eax has 1 character + newline char 
    jz print ;; jump if equal to print
    jmp error ;;jump to error otherwise

print:
    ;; Print success message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, success_msg
    mov edx, msgSuccessLen
    int 0x80 ;; trigger sys_interrupt



    
    mov dword [line_counter], 42 ;; counter for triangle loop

triangle_loop:
    ;; print character
    mov dword [char_counter], 2 ;;set counter for char_loop
    char_loop:
        ;;print character
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, LetterA ;;[char_buff-1]
        mov edx, lenLetterA
        int 0x80
        ;;check number of times 
        dec dword [char_counter]
        cmp dword [char_counter], 0
        jg char_loop


    end_char_loop:

    ;; print newline
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, 10 ;;newline character
    mov edx, 2
    int 0x80 ;; trigger sys_int

    dec dword [line_counter] ;;decrement counter
    cmp dword [line_counter], 42 ;; check if meets requirements
    jz exit
    jmp triangle_loop

    

    
    
    



    

error:
    ;;Print error message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, error_msg
    mov edx, msgErrorLen
    int 0x80 ;; trigger sys_interrupt
    jmp exit
    

exit:
    ;;EXIT PROGRAM
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