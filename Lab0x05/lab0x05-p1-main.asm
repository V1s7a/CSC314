;; define some symbols
    BYTES_PER_LINE equ 8
    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2
    SYS_EXIT equ 1

section .data
    enterTxtMsg db "Enter a line of text: ", 0x0A
    enterTxtMsg_len equ $ - enterTxtMsg
    enterSearchCharMsg db "Enter a character to search for: ", 0x0A
    enterSearchCharMsg_len equ $ - enterSearchCharMsg
    enterRepCharMsg db "Enter a replacement character: ", 0x0A
    enterRepCharMsg_len equ $ - enterRepCharMsg
    BUFFER_SIZE equ 256
    searchChar db 0
    repChar db 0

section .bss
    BUFFER resb BUFFER_SIZE
    input_size resb 4

section .text
    global _start
    extern _replaceChar ;;link external function from library

_start:
    ;;initialize variables
    mov byte [repChar], 0
    mov byte [searchChar], 0

    ;;ask for input and store input

    ;;ask for line of text input
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, enterTxtMsg
    mov edx, enterTxtMsg_len
    int 0x80 ;; trigger sys interrupt

    ;;read line of text
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, BUFFER
    mov edx, BUFFER_SIZE
    int 0x80 ;; trigger sys interrupt

    dec eax ;; subtract one from count to account for newline
    mov [input_size], eax ;;copy number of bytes from counter

    ;; ask for search char
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, enterSearchCharMsg
    mov edx, enterSearchCharMsg_len
    int 0x80 ;; trigger sys interrupt

    ;;read search car
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, searchChar
    mov edx, 1
    int 0x80 ;; trigger sys interrupt

    ;; read and discard newline char otherwise will input newline into next read
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, repChar
    mov edx, 1
    int 0x80 ;; trigger sys interrupt

    ;;ask for replacement char
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, enterRepCharMsg
    mov edx, enterRepCharMsg_len
    int 0x80 ;; trigger sys interrupt

    ;; read replacement char
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, repChar
    mov edx, 1
    int 0x80 ;; trigger sys interrupt


    cmp byte [BUFFER], 0x0A ;; check if buffer is a newline
    je exit

    ;; call library function _replaceChar
    ;; push parameters to the stack
    
    mov eax, [repChar]
    push eax;; push the text array to the stack
    mov eax, [searchChar]
    push eax ;; push the length of text
    mov eax, [input_size]
    push eax;; push the searchChar to the stack
    mov eax, BUFFER
    push eax ;; push the replacement char to the stack
    
    
    
    
    

    ;;call the function
    call _replaceChar
    add esp, 16 ;;clean up stack

    ;; print output for checking
    mov [input_size], eax ;; save value of input size after function call from eax

    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, BUFFER  ;;mov ecx, [esp - 16]
    mov edx, [input_size]
    int 0x80 ;; trigger sys interrupt


exit:
    ;;exit program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80 ;; trigger sys interrupt