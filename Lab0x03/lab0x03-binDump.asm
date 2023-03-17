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
    NEWLINE_BUF db 0x0A ;; output buffer for just a newline character

section .bss
    inputByteCount resb 4 ;; use 32-bit integers unless you have a good reason not to
    OUTPUT_BUFFER resb 9  ;; output buffer needs 8 binary digits and a space
    INPUT_BUFFER resb 1024 ;;1kb input buffer
    IN_BUF_SIZE equ $ - INPUT_BUFFER

section .text
    global _start

_start:

    ;; Line_Loop -- repeat for each line(buffer) of text
line_loop:
    mov eax, SYS_READ
    mov ebx, FD_STDIN
    mov ecx, INPUT_BUFFER
    mov edx, IN_BUF_SIZE
    int 0x80 ;; trigger sys interrupt

    cmp eax, 0
    jle exit_line_loop

    mov [inputByteCount], eax ;; save the input byte count

    ;; Byte_loop within line loop -- repeat for each input byte in the input buffer

    xor esi, esi ;; using esi as byte offset, initializing to zero. Could mov esi, 0 xor is faster
byte_loop:
    ;; Convert the current byte to hexcidecimal, put it in the output buffer
    mov AL, [INPUT_BUFFER + esi] ;; copying the next byte to convert into register AL
    
    ;; turn bits in register AL to ascii 1's and 0's in the output buffer
    ;; bit_loop to look at one bit at a time in our byte_loop
    xor ebx, ebx ;; using ebx as bit loop counter (also the offset in the output buffer)
bit_loop:
    ;; look at next bit
    shl AL, 1 ;;shift one bit to the left and see what falls out
    jc one_bit
    mov byte [OUTPUT_BUFFER + ebx], '0' ;; zero bit -- copy ascii char 0
    jmp after_one_bit

one_bit:
    mov byte [OUTPUT_BUFFER + ebx], '1' ;; one bit -- copy ascii char 1 into next byte of output buffer

after_one_bit:
    inc ebx
    cmp ebx, 8
    jl bit_loop

    mov byte [OUTPUT_BUFFER + 8], ' ' ;; space char after bit chars into the output buffer

    mov eax, SYS_WRITE    ;; needs bytes in memory
    mov ebx, FD_STDOUT
    mov ecx, OUTPUT_BUFFER
    mov edx, 9         ;; how many ascii bytes to print? 8 binary digits and a space
    int 0x80 ;; trigger sys interrrupt

    inc esi ;; increnet offset counter
    inc edi ;; increment bytes printed counter
    

    ;; if we have done a multiple of bytes per line, we want to print newline character
    cmp edi, BYTES_PER_LINE
    jne after_print_newline ;; nothing else to do so goto next character
    
    ;;print newline character
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1  ;;just printing one newline character
    int 0x80 ;; trigger sys interrupt
    xor edi, edi ;;reset bytes printed counter to zero

after_print_newline:
    cmp esi, [inputByteCount]
    jl byte_loop


exit_byte_loop: ;; where byte loop exits, not needed but helpful
    jmp line_loop ;;we've proccessed all input characters from the line, so jump back up to read another line of input
    ;; print another newline here
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, 0x0A ;;needed to change from newline buffer (don't know why)
    mov edx, 1
    int 0x80


exit_line_loop:
    ;; nothing left to do
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80 ;; trigger sys exit