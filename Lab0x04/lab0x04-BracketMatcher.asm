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
    ;;program messages
    expectedParenthesisErrorMsg db "Expected '(' ')' mismatch", 0x0A
    expectedParenthesisErrorMsg_len equ $ - expectedParenthesisErrorMsg
    expectedBoxBracketErrorMsg db "Expected '[' ']' mismatch", 0x0A
    expectedBoxBracketErrorMsg_len equ $ - expectedBoxBracketErrorMsg
    expectedCurlErrorMsg db "Expected '{' '}' mismatch", 0x0A
    expectedCurlErrorMsg_len equ $ - expectedCurlErrorMsg
    BracketsMatchedMsg db "All brackets matched", 0x0A
    BracketsMatchedMsg_len equ $- BracketsMatchedMsg
    FailedMismatchMsg db "Brackets mismatched", 0x0A ;;failsafe mesage if there is brackets left in stack
    FailedMismatchMsg_len equ $ - FailedMismatchMsg

section .bss
    inputByteCount resb 8 ;; use 32-bit integers unless you have a good reason not to
    INPUT_BUFFER resb 2048 ;;1kb input buffer
    IN_BUF_SIZE equ $ - INPUT_BUFFER

section .text
    global _start

_start:
    ;; initialize stack
    mov ebp, esp
    push dword 0 ;; initialize stack with zero so there is a last check character

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

    mov esi, INPUT_BUFFER ;;set esi to beginning of input buffer
    cld ;; change direction flag to increment for lodsb
    byte_loop:
        ;; Compare each byte and move open brackets to stack and compare to close brackets
        lodsb ;; copy next byte into al
        cmp al, 0 ;;check if string is empty
        je line_loop ;; all of string is proccessed jump back to read another line
 

        ;;compare if opening brackets
        cmp al, '('
        je open_bracket
        cmp al, '['
        je open_bracket
        cmp al, '{'
        je open_bracket
        
        ;;compare if closing bracket
        cmp al, ')'
        je parenthesis
        cmp al, ']'
        je boxBrackets
        cmp al, '}'
        je curls

        ;;otherwise ignore all else and jump back to beginning
        jmp byte_loop
    

open_bracket:
    ;;push open bracket onto the stack
    ;; remember al is contained in eax as the lower 8 bits
    push eax
    ;;return to byte loop
    jmp byte_loop

parenthesis:
    ;; check if there is a match
    pop eax ;; pop bracket off stack
    cmp al, '('
    jne expectedParenthesisError ;; print mismatch error for parenthesis
    jmp byte_loop
    
boxBrackets:
    ;; check if there is a match
    pop eax
    cmp al, '['
    jne expectedBoxBracketError ;; print mismatch error for box brackets
    jmp byte_loop

curls:
    ;; check if there is a match
    pop eax
    cmp al, '{'
    jne expectedCurlError ;; print mismatch error for parenthesis
    jmp byte_loop

expectedParenthesisError:
    ;; print mismatch message and exit program
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, expectedParenthesisErrorMsg
    mov edx, expectedParenthesisErrorMsg_len
    int 0x80 ;; trigger sys interrupt
    jmp exit

expectedBoxBracketError:
    ;; print mismatch message and exit program
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, expectedBoxBracketErrorMsg
    mov edx, expectedBoxBracketErrorMsg_len
    int 0x80 ;; trigger sys interrupt
    jmp exit

expectedCurlError:
    ;; print mismatch message and exit program
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, expectedCurlErrorMsg
    mov edx, expectedCurlErrorMsg_len
    int 0x80 ;; trigger sys interrupt
    jmp exit


exit_line_loop:
    ;; check if anything if left in the stack
    pop eax
    cmp al, 0
    jne print_failed
    ;; print All match message and exit program
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, BracketsMatchedMsg
    mov edx, BracketsMatchedMsg_len
    int 0x80 ;; trigger sys interrupt
    jmp exit

print_failed:
    ;; print mismatch message and exit program
    mov eax, SYS_WRITE
    mov ebx, FD_STDOUT
    mov ecx, FailedMismatchMsg
    mov edx, FailedMismatchMsg_len
    int 0x80 ;; trigger sys interrupt
    jmp exit

exit:
    ;; nothing left to do
    mov eax, SYS_EXIT
    mov ebx, 0
    int 0x80 ;; trigger sys exit