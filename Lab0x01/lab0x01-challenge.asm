;First program for CSC314 - Colton Willits
section .data ;Define data section
    ; msgA is a label that represents where the first byte that will be in memory
    ; db is a pseudo-command in nasm that is to the assembler it is not a machine instruction
    ; db tell assembler that the following is bytes of data
    ;Defines bytes of data in .data section think list [] ascii characters
    ;0x0A hexidicimal number 10 for newline can put 10 in nasm
    ;Can be ascii text characters in quotes or comma seperated numbers
      ; this is "then" in hex note letters can be 
    ;S --> 83 or 0x53 and h --> a 104 or 0x68
    msgA db "She packed my bags last night pre-flight", 0x0A, \
            "Zero hour 9:00 a.m.", 0x0A, \
            "And I'm gonna be high", 0x0A, \
            "As a kite by", 0x20, 0x74, 0x68, 0x65, 0x6E , 0x0A
    msgB db "I miss the Earth so much I miss my wife", 10

    msgC db "This is so much better than the semester I spent programming MIPS", 10

    msgAlen equ $ - msgA ;figure out how many bytes are in a label
    ;msglen is the new symbol being defined not a address ro a label
    ;equ is a command to define the value of the symbol think =
    ;$ is the address of the next byte or instruction in the program
    msgBlen equ $ - msgB ;get bytes in list msgB
    msgClen equ $ - msgC ; get bytes in list msgC
section .text ;where instructions go
global _start ; link label to linker
_start: ;label used to start program
;setup for int instruction move data to registers
    mov eax, 4 ;copying integer 4 into register eax
    ; 4 in eax means print bytes on interrupt think .WriteLine() in C#
    mov ebx, 1 ;copying a constant integer 1 into register ebx
    ;1 is the file descriptor to Stdout of the program think console. in C#
    mov ecx, msgA ;copying address from label, msgA, into register ecx
    ; processes "write" to find starting address labeled msgA
    mov edx, msgAlen ;copying a 101 into register edx EDIT: changed to a symbol holding value of bytes
    ;101 is the number of bytes that will be read from edx register on interrupt
    int 0x80 ; "int" instruction triggers and interrupt, of type 0x80 or 128
    ; Challenge write next verse
    ;; use the int 0x80 to trigger another interrupt that does that wite
    ;set registers
    mov eax, 4 ;call write
    mov ebx, 1 ; to console or stdout
    mov ecx, msgB ; header of block of data to be printed
    mov edx, msgBlen ;tells system to print 40 bytes from header EDIT: changed to symbol holding value of bytes
    int 0x80 ; invoke interrupt

    ;Challenge message
    mov eax, 4 ;call write on interrupt
    mov ebx, 1 ;have it use stdout
    mov ecx, msgC ;address to list of bytes
    mov edx, msgClen ;length of bytes in list
    int 0x80 ;invoke interrupt


    ;set up another system call to exit
    mov eax, 1 ; copy 1 to register eax, 1 is used to sys_exit() on interrupt
    mov ebx, 0 ; return 0 for program return code - program completion successful
    int 0x80 ; invoke interrupt

    





