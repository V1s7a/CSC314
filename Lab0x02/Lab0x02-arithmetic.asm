
section .data ;;initialized data

    x dd 0x2a ;; (42 in hexadecimal) dd --> means "data double-word", allocate memory for list of 32 bit integer
    y dd 1001 ;; in this case just "lists" just one integer each
    z dd -88 ;;

section .bss ;; uninitialize allocated memory

    this resd 1 ;;reserves 1 4 byte chunk of memory
    that resb 4 ;; reserves 4 1 byte chunks of memory (same as above)

section .text

_start:

    mov eax, [x] ;; move data at address x to register eax
                 ;; an [address] inside square brackets refers to data at that address
                 ;; similar to pointers in C, if you define pointer: int *x;
                 ;; later x by itself is a pointer to somewhere in memory
                 ;; but *x is the "dereferenced pointer", means the contents of the memory that is pointed to by x
                 ;;how many bytes are copied to eax?
                 ;; by default, the number of bytes will match the register (4 bytes)
                 ;; If there is any ambiguity in the instruction, then you much specifiy the size of the operation
    mov ebx, [y]
    add eax, ebx ;;add the value of ebx to eax with the result being stored in eax
                 ;; remember in NASM/intel syntax, the *destination* of an operation is listed first
                 
    mov eax, 1 ;; preping for sys exit call
    mov ebx, 0 ;; return 0 for success
    int 0x80 ;; trigger sys call
