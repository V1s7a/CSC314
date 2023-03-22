;; define some symbols

    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2

section .data
    fizzMsg db " Fizz", 0x0A
    fizzMsgLen equ $-fizzMsg
    buzzMsg db " Buzz", 0x0A
    buzzLen equ $-buzzMsg
    fizzbuzz db " Fizz Buzz", 0x0A
    fizzbuzzlen equ $-fizzbuzz
    char db "Z"
    charLen equ 1
    newline db 0x0A
    newlineLen equ 1

section .bss
    counter resb 1024 ;; reserve 1kb for counter...
    char_counter resb 1024 ;; allocate memory for character counter..
    three_rem resb 4 ;;allocate memory for remainder of division by 3
    five_rem resb 4; allocate memor for remainder of division by 5


section .text
    extern _start

_start:
    ;; start loop
    mov dword [counter], 0 ;; set counter to 1
    number_loop:
    inc byte [counter] ;; increment the counter and also initialize to 1 from 0
    mov esi, dword [counter]
    mov dword [char_counter], esi ;; mov the number of Zs to be printed to the char counter
        char_loop:
            ;;Print Character
            mov eax, SYS_WRITE
            mov ebx, FD_STDOUT
            mov ecx, char 
            mov edx, charLen
            int 0x80
            ;;check number of times printed
            dec dword [char_counter]
            cmp dword [char_counter], 0
            jg char_loop
    
    
    ;;check if fizz or buzz needs to be printed
    ;; division for remainders first set remainders to three_rem and five_rem
        ;;divide by 3
        xor eax, eax
        xor ebx, ebx
        xor edx, edx
        mov eax, [counter] ;; set counter to numerator
        mov ebx, 3 ;; set denominator to 3
        div ebx ;;divide eax by ebx
        mov dword [three_rem], edx
        
        ;;divide by 5
        xor eax, eax
        xor ebx, ebx
        xor edx, edx
        mov eax, [counter] ;; set counter to numerator
        mov ebx, 5 ;; set denominator to 5
        div ebx ;;divide eax by ebx
        mov dword [five_rem], edx


    ;; check if both were divisible (check if both cmp to 0)
    mov eax, dword [three_rem]
    mov ebx, dword [five_rem]
    cmp eax, 0 ;; compare three remainder to 0
    jne both_not_equal ;; jump if not equal to 0
    cmp ebx, 0 ;; compare five remainder to 0
    jne both_not_equal ;; jump if not equal to zero

    jmp print_fizzbuzz ;; jump to print fizzbuzz message

    both_not_equal:
    ;;check if divisible by 3 if so print fizz
    mov eax, dword [three_rem] ;; move remainder to eax
    cmp eax, 0  ;; compare if remainder is equal to zero
    je print_fizz ;; if equal jump to print fizz message

    ;; check if divisible by 5 if so print buzz
    mov eax, dword [five_rem] ;; move remainder to eax
    cmp eax, 0 ;; compare if remainder is equal to zero
    je print_buzz ;; if equal jump to print buzz message

    ;;all else print newline
    jmp print_newline

print_buzz:
    ;;Print buzz message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, buzzMsg
    mov edx, buzzLen
    int 0x80
    jmp number_loop

print_fizz:
    ;;Print buzz message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, fizzMsg
    mov edx, fizzMsgLen
    int 0x80
    jmp number_loop

print_fizzbuzz:
    ;;Print buzz message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, fizzbuzz
    mov edx, fizzbuzzlen
    int 0x80
    jmp number_loop

print_newline:
    ;;Print buzz message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, newline
    mov edx, newlineLen
    int 0x80
    jmp number_loop
