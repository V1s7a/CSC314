section .data
    newline db 0x0A
    num_header db "Numbers", 9, "Running Total", 0x0A, 0
    num_fmt db "%d", 9, 0 ;format string for printing numbers
    total_fmt db "%d", 0 ;format string for printing running total

section .text
    ;; define global variables for library here
    global _replaceChar
    global _sumAndPrintList
    extern puts
    extern printf
    extern putchar

    _replaceChar:
        push ebp ;; save current stack pointer
        mov ebp, esp ;; move to different area of the stack to avoid other program data

        ;; get function parameters
        mov ebx, [ebp+8]  ;; textPtr
        mov ecx, [ebp+12] ;; length
        mov dl, [ebp+16] ;; searchChar
        mov al, [ebp+20] ;; repChar

        xor esi, esi ;; eax will be the counter, so set to 0

    loop:
        cmp esi, ecx ;; compare counter to array length, see if counter reached length
        je done ;;jump to done if counter has reached array length

        mov dh, [ebx+esi] ;; load character from array
        cmp dh, dl ;; compare against search char
        jne skip_replace ;; if not equal jump to skip replace

        
        mov byte [ebx+esi], al ;; replace with repChar
        ;; no need to increment esi as the replaced character is already accounted for
        jmp loop

    skip_replace:
        inc esi ;;increment counter
        jmp loop

    done:
        ;; clean up and return
        mov esp, ebp ;;restore stack pointer
        pop ebp ;;restore previous stack pointer position
        ret    ;; return counter in eax

_sumAndPrintList:
    push ebp ;; save current stack pointer
    mov ebp, esp ;; move to different area of the stack to avoid other program data

    ;;Set the sum to zero, sum is stored in register eax
    xor eax, eax

    ;;Print header
    push dword num_header
    call puts
    add esp, 4

    ;; get function parameters
    mov esi, [ebp+8]  ;; list
    mov edx, [ebp+12] ;; length

    ;; initialize running total to zero
    xor ebx, ebx

    ;;loop through list
    xor edi, edi ;; index

    sum_loop:
        cmp edi, [ebp + 12]
        jge sum_done    ;; jumps to done which exits program

        ;; print number
        push dword [esi + edi *4] ;;push value of index position on list of numbers
        push dword num_fmt
        call printf
        add esp, 8

        ;;Update sum and print running total
        add eax, [esi + edi * 4] ;; add current number to sum
        add ebx, eax ;; add sum to running total
        push ebx ;; push running total
        push dword total_fmt
        call printf
        add esp, 8

        ;;print newline
        push dword newline
        call putchar
        add esp, 4

        ;;increment index and  loop
        inc edi
        jmp sum_loop

    sum_done:
        ;; print final running total
        push dword ebx
        push dword total_fmt
        call printf
        add esp, 8

        ;; clean up and return sum
        mov eax, ebx ;; return running total
        pop ebp
        ret
