section .data
    msgA db "Please enter a two characters to make a double triangle:", 0x0A ;;startup message
    msgALen equ $-msgA ;; calculate length of msgA
    error_msg db "Error: entered more than one character!" ;;error message
    msgErrorLen equ $-error_msg ;; calculate length of error_msg
    success_msg db "Here is your triangle", 0x0A ;; success message
    msgSuccessLen equ $-success_msg
    NEWLINE_BUF db 0x0A ;; newline character
    lenNewline equ $-NEWLINE_BUF
    ;;msgALen equ 52
    ;;msgErrorLen equ 39
    ;;msgSuccessLen equ 22
    LetterA db "A"
    lenLetterA equ 1

section .bss
    LINES equ 42 ;; set the number of lines to print to 42
    char_buff resb 3;; set one byte for character buffer
    inputCharCount resd 2 ;; allocate space to store number of characters for input
    line_counter resb 4 ;; allocate 4 bytes to line counter
    char_counter resb 4 ;; allocate 4 bytes to char counter
    second_char_counter resb 4 ;; allocate 4 bytes to second char counter

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
    cmp eax, 3 ;; compare if eax has 2 characters + newline char 
    jz print ;; jump if equal to print
    jmp error ;;jump to error otherwise

print:
    ;; Print success message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, success_msg
    mov edx, msgSuccessLen
    int 0x80 ;; trigger sys_interrupt

    mov dword [line_counter], 1;; counter for triangle loop

triangle_loop:
    ;; print character
    mov esi, dword [line_counter]
    mov dword [char_counter], esi ;;set counter for char_loop
    mov edi, 42 ;; set max number
    sub edi, esi
    mov dword [second_char_counter], edi ;; set counter for second_char_loop
    first_char_loop:
        ;;print first character
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, char_buff 
        mov edx, lenLetterA
        int 0x80
        ;;check number of times 
        dec dword [char_counter]
        cmp dword [char_counter], 0
        jg first_char_loop
        jmp second_char_loop

    second_char_loop:
        ;;print second character
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, char_buff+1
        mov edx, lenLetterA
        int 0x80
        ;;check number of times 
        dec dword [second_char_counter]
        cmp dword [second_char_counter], 0
        jg second_char_loop
        jmp exit_char_loop

    exit_char_loop:
        ;; print newline
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, NEWLINE_BUF ;;newline character
        mov edx, lenNewline
        int 0x80 ;; trigger sys_int

    inc dword [line_counter] ;;decrement counter
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
    

;; define some symbols

    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2