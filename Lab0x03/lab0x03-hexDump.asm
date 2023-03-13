;; define some symbols
    BYTES_PER_LINE equ 8
    SYS_READ equ 3
    SYS_WRITE equ 4
    SYS_EXIT equ 1
    FD_STDIN equ 0
    FD_STDOUT equ 1
    FD_STDERR equ 2

.data
    INPUT_BUFFER db 1024 ;;1kb input buffer
    IN_BUF_SIZE equ $ - INPUT_BUFFER

.bss
    inputByteCount resb 4 ;; use 32-bit integers unless you have a good reason not to

.text
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
    






exit_line_loop: