section .data


section .bss
    ;; define a symbol the address of the start of our input buffer
    ;; a block of 1024 bytes 1kb
    ;; resb --> reserve bytes and is used for unitialized blocks of memory
    BUF_SIZE equ 1024
    inputBuffer resb BUF_SIZE
    ;; There are also resw, resd, (reserve word and double word)
    inputByteCount resd 1 ;; reserving space for 1 integer, could also say resb 4 reserves 4 byte word

section .text

    extern _start

_start:


mimic_loop:
    ;;read line of text from user
    ;; need system call: sys_read
    mov eax, SYS_READ ;;3 is the code for sys read
    mov ebx, FD_STDIN ;;the file descriptor that represents stdin defined below
    mov ecx, inputBuffer ;;address of location in memory where we want to store characters that we read
    mov edx, BUF_SIZE   ;; tells sys_read the MAXIMUM number of bytes to read & store
                        ;sys_read can read fewer bytes than the maximum up to a newline character

    int 0x80 ;; interrupt to trigger the sys_read system call

    ;; how to know how many bytes it read in?
    ;; sys_calls puth their return value in register EAX
    ;; sys_read returns a count of how many it read in and stores


    ;; GOOD HABIT!!
    ;;if return value is important, save it in a variable
    ;;Don't have to worry about the value being destroyed
    mov [inputByteCount], eax ;; copy number of bytes that sys_read stored to a safe place


    ;;after sys_read if we hit EOF or error jump out of loop
    cmp dword [inputByteCount], 0 ;; only work if we have not messed with eax
    jle end_mimic_loop ;;this is a lot like a break in C

    ;;print line back
    ;; challenge: figure out how to print back out
    ;;mov edx, eax ;;move number of characters from eax register to edx before sys_write ( NOT best practice)
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, inputBuffer ;;start address of text we want to print
                        ;; yes, you can use address of inputBuffer as the address of text to output
    mov edx, [inputByteCount] ;; move content from variable inputByteCount to register edx
    int 0x80 ;; trigger sys_write

    ;;jump back and do it again, exit if hit EOF
    jmp mimic_loop

end_mimic_loop:



;EXIT
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