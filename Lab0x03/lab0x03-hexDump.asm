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
    OUTPUT_BUFFER resb 3  ;; output buffer just big enough for two hex digits and space
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
    mov AH, AL    ;; make a copy of the byte -- use AL for one nibble, and AH to get the other nibble
    and AL, 0x0F  ;; masking register AL, to get the low order nibble
    shr AH, 4     ;; shifting register AH 4 bits to the right to get the high order nibble

    cmp AL, 10 ;; check if nibble is < 10
    jae low_nibble_hex_AtoF ;;jump if in range 10 to 15 or hex digit A to F
    ;; hex 0..9
    add AL, '0' ;; add to the nibble value the ASCII code of character "0" or dec 48 or hex 0x30
    jmp low_nibble_skip_AtoF

low_nibble_hex_AtoF:
    add AL, 0x37 ;; adding the nibble value to 10 less than ASCII character 'A'


low_nibble_skip_AtoF:
    ;; at this point we know that AL contains the ASCII code to the hex digit for the lower order nibble of the byte

    cmp AH, 10 ;; check if nibble is < 10
    jae high_nibble_hex_AtoF ;;jump if in range 10 to 15 or hex digit A to F
    ;; hex 0..9
    add AH, '0' ;; add to the nibble value the ASCII code of character "0" or dec 48 or hex 0x30
    jmp high_nibble_skip_AtoF

high_nibble_hex_AtoF:
    add AH, 0x37 ;; adding the nibble value to 10 less than ASCII character 'A'


high_nibble_skip_AtoF:
    ;; at this point in our program we know AH contains the ascii code for the hex digit of the higher order nibble of the byte
    
    ;;now print ascii character for the hex digits, and a space or newline afterthem
    ;; sys_write needs those bytes in memory to do its thing
    mov [OUTPUT_BUFFER], AH ;; put the high order digit character in the first byte of the output buffer
    mov [OUTPUT_BUFFER +1], AL ;; put the low order byte in the next byte of the output buffer
    mov byte [OUTPUT_BUFFER +2], ' ' ;; put space ascii in the next byte of output buffer

    mov eax, SYS_WRITE    ;; needs bytes in memory
    mov ebx, FD_STDOUT
    mov ecx, OUTPUT_BUFFER
    mov edx, 3         ;; how many to print?
    int 0x80 ;; trigger sys interrrupt

    inc esi ;; increnet offset counter
    cmp esi, [inputByteCount]
    jge exit_byte_loop

    inc edi ;; increment bytes printed counter
    ;; if we have done a multiple of bytes per line, we want to print newline character
    cmp edi, BYTES_PER_LINE
    jne byte_loop ;; nothing else to do so goto next character
    
    ;;print newline character
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, NEWLINE_BUF
    mov edx, 1  ;;just printing one newline character
    int 0x80 ;; trigger sys interrupt
    xor edi, edi ;;reset bytes printed counter to zero
    jmp byte_loop

exit_byte_loop:
    jmp line_loop ;;we've proccessed all input characters from the line, so jump back up to read another line of input



exit_line_loop:
    ;; nothing left to do
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80 ;; trigger sys exit