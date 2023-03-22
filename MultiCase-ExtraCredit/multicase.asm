;; Colton Willits
;; Dr. Graham
;; CSC-314
;; This is an experimental program to see if cmp can be used in conjuction
;; with multiple conditional jump statement by analyzing the flag set by the comparision.
;; The idea behind this program is there is a hardcoded number that one has to guess between 1 and 10
;; The attempted program in C is also included in the same zipfile in multicase.c The reversed C outpu
;; for multicase.asm can be found in multicaseRev.c

;; define some symbols

    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2

section .data
    instructions db "Guess a number between 1 and 10, enter 0 to exit the program respectfully", 0x0A,"If number is guessed correctly program with automatically exit", 0x0A
    instructLen equ $-instructions ;; length of instructions
    actionCall db "Guess a number between 1 and 10", 0x0A
    aCallLen equ $-actionCall ;; length of call to action message
    higherMsg db "Try a number thats higher", 0x0A
    highMsgLen equ $-higherMsg ;; length of higher msg
    lowerMsg db "Try a number thats lower", 0x0A
    lowMsgLen equ $-lowerMsg
    correctMsg db "Correct the number is 7", 0x0A
    correctMsgLen equ $-correctMsg
    exitMsg db "Exiting", 0x0A
    exitMsgLen equ $-exitMsg



section .bss
    INPUT_BUFFER resb 4 ;; reserve 4 bytes for numeric input
    

section .text
    extern _start

_start:
    ;;Print instructions
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, instructions
    mov edx, instructLen
    int 0x80 ;; trigger sys_interrupt

test_loop:
    ;;Print Call to Action
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, actionCall
    mov edx, aCallLen
    int 0x80 ;; trigger sys_interrupt

    ;;Read input
    mov eax, SYS_READ ;;set ups sys read
    mov ebx, FD_STDIN 
    mov ecx, INPUT_BUFFER
    mov edx, 1
    int 0x80 ;; trigger sys_read

    ;;check if exit
    mov esi, '0' ;;move ascii char 0 to register esi
    cmp [INPUT_BUFFER], esi ;; compare if equal to ascii 0
    je exit ;;if so jump to exit
    xor esi, esi ;;reset esi so it can be reused 

    ;;!!!TEST CODE !!!!
    cmp dword [INPUT_BUFFER], 0x37 ;;compare ascii char '7'
    je correct
    jg lower ;; reversed lower -> jl and higher -> jg this should be correct now based on the message
    jl higher ;; to be printed
    jmp test_loop ;;if not proper input just rerun loop



higher:
    ;;Print Higher Message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, higherMsg
    mov edx, highMsgLen
    int 0x80 ;; trigger sys_interrupt
    jmp test_loop ;; jump back to the test loop


lower:
    ;;Print Lower Message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, lowerMsg
    mov edx, lowMsgLen
    int 0x80 ;; trigger sys_interrupt
    jmp test_loop ;; jump back to test loop

correct:
    ;;Print Correct Message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, correctMsg
    mov edx, correctMsgLen
    int 0x80 ;; trigger sys_interrupt

    ;;exit program
    mov eax, 1
    mov ebx, 0
    int 0x80

exit:
    ;;Print exit message
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, exitMsg
    mov edx, exitMsgLen
    int 0x80 ;; trigger sys_interrupt

    ;; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
