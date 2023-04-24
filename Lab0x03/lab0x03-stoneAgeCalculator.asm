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
    ;; operator symbols
    pebble_char db 'o' ;;pebble character
    equalsign db '=' ;; equals char
    addition db '+' ;;addition character
    subtraction db '-' ;;subtraction character
    multiplication db '*' ;; multiplication char
    division db '/' ;; division character
    modulo db '%' ;;modulo character 
    clear db 'c' ;; character to clear buffer
    exit_char db 'x' ;;character to exit program
    startmsg db "Welcome to the stone age.", 0x0A, "We do math with pebbles. o", 0x0A, "=", 0x0A ;;starting message
    startmsg_len equ $ - startmsg ;;length of starting message
    exitmsg db "...returning to your proper time in history.", 0x0A
    exitmsg_len equ $ - exitmsg ;; length of exit message
    syntaxErrormsg db "Ug! What that? You hurt Grog head!", 0x0A, "=", 0x0A ;; syntax error msg
    syntaxErrormsg_len equ $ - syntaxErrormsg ;; length of exit message
    syntaxErrormsg2 db "Ug! Only pebble can be number!", 0x0A
    syntaxErrormsg2_len equ $ - syntaxErrormsg2 ;; length of syntaxErrormsg2
    syntaxErrormsg3 db "Ug! Number too big!", 0x0A ;; Too big number message
    syntaxErrormsg3_len equ $ - syntaxErrormsg3 ;; length of syntaxErrormsg3
    syntaxErrormsg4 db "Ug! Number can't be below nothing.", 0x0A ;; negative number error
    syntaxErrormsg4_len equ $ - syntaxErrormsg4 ;; lenght of syntaxErrormsg4
    newline db 0x0A
    valid_chars db "+-*/%o"


section .bss
    ByteCounter resb 4 ;;reserve  4 bytes for input ByteCounter
    INPUT_BUFFER resb 1024 ;; reserve 1kb for input
    IN_BUF_SIZE equ $ - INPUT_BUFFER
    OUTPUT_BUFFER resb 1024 ;;reserve 1kb for output
    char_counter resb 4 ;;reserve 4 bytes for char_counter
    Counter resb 4 ;;reserve 4 bytes for counter


section .text
    global _start

_start:

    ;;print starting message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, startmsg
    mov edx, startmsg_len
    int 0x80 ;; trigger sys interrupt

math_loop:
    ;;read input
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80 ;; trigger sys interrupt

    ;;remove newline and operand in counter mov number of pebbles into counter
    sub eax, 2 ;; subtract 2 from eax and quotient is stored in eax
    mov [ByteCounter], eax ;; copy value of eax into bytecounter
    

    ;;check input buffer for non-pebbles if not pebbles jump to syntaxError2
    mov esi, INPUT_BUFFER ;;set esi to beginning of INPUT_BUFFER
    inc esi        ;; increment past operator
    mov ecx, dword 0 ;; use ecx as a counter and initialize it to zero
    check_loop:
        mov al, byte [esi] ;;set al to current char
        cmp al, byte 0 ;;check if EOL
        je check_done ;;exit loop
        cmp al, 0x0A ;; check if newline char
        je check_done
        mov edi, valid_chars ;;set edi to beginning of valid_chars string
        mov ecx, dword 0   ;; initialize inner check loop counter

        inner_check_loop:
            mov bl, byte [edi] ;; set current valid char
            cmp bl, byte 0 
            je syntaxError2 ;; current character is invalid then jump to syntaxError2
            cmp al, bl ;;compare current char to current valid char
            je valid_char ;;if they match jump to valid_char
            inc edi ;; move to next valid char
            inc ecx ;; increment inner check loop counter
            jmp inner_check_loop ;;jump back to beginning of inner loop

    valid_char:
        ;; current character is valid move to next character
        inc esi ;; move to next character in input
        jmp check_loop ;; jump back to the beginning of check
    
    check_done: ;; continue in program end of check

    ;;check first input symbols to operators
    mov esi, INPUT_BUFFER ;; copy INPUT_BUFFER to register esi
    movzx eax, byte [esi] ;; copy first byte of esi to eax
    ;;compare if addition
    cmp eax, '+'
    je addition_func
    ;;compare if subtraction
    cmp eax, '-'
    je subtraction_func
    ;;compare if multiplication
    cmp eax, '*'
    je multiplication_func
    ;;compare if division
    cmp eax, '/'
    je division_func
    ;;compare if modulo
    cmp eax, '%'
    je modulo_func
    ;;compare if clear
    cmp eax, 'c'
    je clear_func
    ;;compare if exit
    cmp eax, 'x'
    je exit
    ;;else jump to syntax error 1 wrong operator
    jmp syntaxError1


addition_func:
    mov eax, [Counter]
    mov ebx, [ByteCounter]
    add eax, ebx ;; add the two numbers
    mov dword [Counter], eax ;;move return value in eax to Counter
    jmp print ;; jump to print output

subtraction_func:
    mov eax, [Counter]
    mov ebx, [ByteCounter]
    sub eax, ebx ;; subtract ebx from eax
    mov dword [Counter], eax ;; copy return value in eax to Counter
    test eax, 0x80000000 ;; test if the MSB of eax is set
    jnz syntaxError4   ;; jump to syntaxError4 if the result is negative
    jmp print ;; jump to print output

multiplication_func:
    mov eax, [Counter]
    mov ebx, [ByteCounter]
    mul ebx ;; multiply eax and ebx value is stored in eax
    mov dword [Counter], eax ;; move return value in eax to Counter
    jmp print ;; jump  to print output

division_func:
    xor edx, edx ;;clear edx
    mov eax, [Counter]
    mov ebx, [ByteCounter]
    div ebx ;; divide eax by ebx remainder will be stored in edx
    mov dword [Counter], eax ;; move quotient stored in eax to Counter
    jmp print ;; jump to print output

modulo_func:
    xor edx, edx ;;clear edx
    mov eax, [Counter]
    mov ebx, [ByteCounter]
    div ebx ;; divide eax by ebx remainder will be stored in edx
    mov dword [Counter], edx ;; move output stored in edx to Counter
    jmp print ;; jump to print output

clear_func:
    mov dword [Counter], 0 ;;set Counter to zero
    jmp print ;; jump to print output

print:
    ;;check if number is too big
    cmp dword [Counter], 100 ;;caveman can count past 100
    jg syntaxError3

    ;;print current number of pebbles after calculation
        ;;print equals sign first
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, equalsign
    mov edx, 1
    int 0x80 ;; trigger sys interrupt
        ;;print pebbles loop
    cmp dword [Counter], 0 ;;Check if counter is set to zero
    je exit_pebbles_loop ;; if 0 jump past pebbles_loop
    mov esi, dword [Counter]
    mov dword [char_counter], esi ;; copy value from counter to char_counter
    pebbles_loop:
        ;print character
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, pebble_char
        mov edx, 1
        int 0x80
        ;;check number of times 
        dec dword [char_counter]
        cmp dword [char_counter], 0
        jg pebbles_loop
        ;;print newline char
    exit_pebbles_loop:
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp math_loop ;; jump back to the math_loop



syntaxError1:
    ;;print syntax error message 1
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, syntaxErrormsg
    mov edx, syntaxErrormsg_len
    int 0x80 ;; trigger sys interrupt
    jmp print ;; jump to print output

syntaxError2:
    ;;print syntax error message 2
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, syntaxErrormsg2
    mov edx, syntaxErrormsg2_len
    int 0x80 ;; trigger sys interrupt
    jmp print ;; jump to print output

syntaxError3:
    ;;print syntax error message 3
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, syntaxErrormsg3
    mov edx, syntaxErrormsg3_len
    int 0x80 ;; trigger sys interrupt
    jmp clear_func ;; jump to print output

syntaxError4:
    ;;print syntax error message 3
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, syntaxErrormsg4
    mov edx, syntaxErrormsg4_len
    int 0x80 ;; trigger sys interrupt
    jmp clear_func ;; jump to print output
    
exit:
    ;;print exit message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, exitmsg
    mov edx, exitmsg_len
    int 0x80 ;; trigger sys interrupt

    ;;exit program
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80 ;; trigger sys interrupt