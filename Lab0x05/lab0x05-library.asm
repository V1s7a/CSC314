section .text
    ;; define global variables for library here
    global _replaceChar

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


; section .text
;     ;; define global variables for library here
;     global _replaceChar

;     _replaceChar:
;         push ebp ;; save current stack pointer
;         mov ebp, esp ;; move to different area of the stack to avoid other program data

;     ;; get function parameters
;     mov ebx, [ebp+8]  ;; textPtr
;     mov ecx, [ebp+12] ;; length
;     mov dl, [ebp+16] ;; searchChar
;     mov esi, [ebp+20] ;; repChar

;     xor eax, eax ;; eax will be the counter, so set to 0

;     mov edi, ebx ;; have edi point to beginning to textPtr
;     xor ecx, ecx ;; make ecx counter for the array index

;     loop:
;         cmp ecx, [ebp+12] ;; compare counter to array length, see if counter reached length
;         je done ;;jump to done if counter has reached array length

;         mov al, [edi+ecx] ;; load character from array
;         cmp al, dl ;; compare against search char, using dl since search char is in edx and the single char is in lower byte
;         je replace ;; if equal jump to perform replace action

;         ;;otherwise increment and jump back
;         inc ecx ;;increment counter
;         jmp loop 

;     replace:
;         mov [ebx+ecx], al ;;replace with repChar
;         inc ecx
;         jmp loop


;     done:
;         ;; clean up and return
;         mov esp, ebp ;;restore stack pointer
;         pop ebp ;;restore previous stack pointer position
;         ret    ;; return counter in eax