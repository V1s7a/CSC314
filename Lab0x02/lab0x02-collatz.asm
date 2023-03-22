;; define some symbols

    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2

section .data
    instructions db "Please enter row of asterisks, with length equal to your starting number", 0x0A," for a collatz sequence: "
    instructLen equ $-instructions
    successMsg db "Here is your collatz sequence:", 0x0A
    successLen equ $-successMsg
    asterisk db "*"
    asterLen equ 1
    newline db 0x0A
    newlineLen equ 1



section .bss
    BUF_SIZE equ 1024
    inputBuffer resb BUF_SIZE
    inputCharCount resb 4 ;;allocate 4 bytes to the inputCharCount
    char_counter resb 4 ;;allocate 4 bytes to the char counter
    remainder resb 4 ;; allocate 4 bytes for the remainder output

section .text
    extern _start

_start:
    ;;print instructions
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, instructions
    mov edx, instructLen
    int 0x80

    ;;Read input of characters
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, inputBuffer
    mov edx, BUF_SIZE
    int 0x80

    mov [inputCharCount], eax ;; copy number of chars from eax after SYS_READ
    dec dword [inputCharCount] ;; remove newline char
    ;; print success message before starting collatz sequence
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, successMsg
    mov edx, successLen
    int 0x80

    collatz_loop:
        ;; print number of characters through loop
        mov esi, [inputCharCount]
        mov [char_counter], esi
        
        char_loop:
            ;;print character
            mov eax, SYS_WRITE
            mov ebx, FD_STDOUT
            mov ecx, asterisk
            mov edx, asterLen
            int 0x80
            ;;check number of times 
            dec dword [char_counter]
            cmp dword [char_counter], 0
            jg char_loop
        
        ;; print newline
        mov eax, SYS_WRITE
        mov ebx, FD_STDOUT
        mov ecx, newline
        mov edx, newlineLen
        int 0x80
        
        ;;check if exit conditions are met
        cmp dword [inputCharCount], 1
        je exit

        ;;do calculations on inputCharBuffer
        ;; even numbers get halved
        ;; odd numbers multiplied by 3 and then plus 1

        ;;check if odd or even
        xor eax, eax
        xor ebx, ebx
        xor edx, edx
        mov eax, [inputCharCount] ;; set counter to numerator
        mov ebx, 2 ;; set denominator to 3
        div ebx ;;divide eax by ebx
        cmp edx, 0
        jne odd_calc
        ;; Even calculation is already done with result in eax
        mov dword [inputCharCount], eax ;; copy quotient to inputCharCount
        jmp collatz_loop

    odd_calc:
        ;; operation to be done 3x+1
        xor eax, eax ;;clear contents of eax and edx
        xor ebx, ebx 
        mov eax, [inputCharCount] ;; copy input char count into eax
        mov ebx, 3 ;; copy value 3 to edx
        mul ebx ;; multiply eax and edx registers output is stored in eax
        inc eax ;; increment eax by one to finish the +1 of the operation
        mov dword [inputCharCount], eax ;; copy final operation value to inputCharCount
        jmp collatz_loop


exit:
    ;EXIT
    mov eax, 1
    mov ebx, 0
    int 0x80