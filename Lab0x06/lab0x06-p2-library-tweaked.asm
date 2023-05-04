global sumOfSumsAtoB_tweaked
extern __x86.get_pc_thunk.ax
extern _GLOBAL_OFFSET_TABLE_

section .text

sumOfSumsAtoB_tweaked:
    push ebp
    mov ebp, esp
    sub esp, 12  ; only need to allocate space for 3 variables instead of 4

    ; calculate the address of the global offset table and store in eax
    call __x86.get_pc_thunk.ax
    add eax, [_GLOBAL_OFFSET_TABLE_]

    ; initialize variables
    mov ecx, [ebp+8]  ; use ecx as a counter for the outer loop
    mov eax, 0        ; initialize the total sum to 0
    jmp .outer_loop   ; jump to the start of the outer loop

.inner_loop:
    add ebx, edx  ; add the inner loop counter to the inner sum
    add edx, 1    ; increment the inner loop counter
    cmp edx, ecx  ; compare the inner loop counter with the outer loop counter
    jle .inner_loop  ; if it's less than or equal, continue the inner loop

    add eax, ebx  ; add the inner sum to the total sum

.outer_loop:
    mov ebx, 0      ; initialize the inner sum to 0
    mov edx, ecx    ; use edx as a counter for the inner loop
    sub ecx, 1      ; decrement the outer loop counter
    jnz .inner_loop ; if it's not zero, continue the outer loop

    leave         ; restore the stack pointer
    ret           ; return from the function


; global sumOfSumsAtoB_tweaked
; extern __x86.get_pc_thunk.ax
; extern _GLOBAL_OFFSET_TABLE_


; section .text

; sumOfSumsAtoB_tweaked:
;     push ebp
;     mov ebp, esp
;     sub esp, 16

;     ; calculate the address of the global offset table and store in eax
;     call __x86.get_pc_thunk.ax
;     add eax, [_GLOBAL_OFFSET_TABLE_]

;     ; initialize variables
;     mov edx, [ebp+8]       ; upper bound of the outer sum
;     mov dword [ebp-12], edx    ; initialize the outer sum to upper bound
;     mov dword [ebp-8], 0        ; initialize the inner sum to 0
;     mov dword [ebp-4], 0        ; initialize the total sum to 0
;     jmp .L2

; .L3:
;     mov eax, [ebp-12]           ; load the current outer sum index
;     add dword [ebp-8], eax      ; add the index to the inner sum
;     mov eax, [ebp-8]            ; load the current inner sum
;     add dword [ebp-4], eax      ; add the inner sum to the total sum
;     add dword [ebp-12], 1       ; increment the outer sum index

; .L2:
; 	; loop through the outer sum
;     mov eax, [ebp-12]           ; load the current outer sum index
;     cmp eax, [ebp+12]           ; compare it with the upper bound
;     jle .L3                     ; if it's less than or equal, continue the loop

;     mov eax, [ebp-4]            ; move the total sum to eax
;     leave                       ; restore the stack pointer
;     ret                         ; return from the function




;;;;;;;;;;; ORIGINAL CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;

; 	.file	"lab0x06-p2-library.c"
; 	.text
; 	.globl	sumOfSumsAtoB
; 	.type	sumOfSumsAtoB, @function
; sumOfSumsAtoB:
; .LFB0:
; 	.cfi_startproc
; 	pushl	%ebp
; 	.cfi_def_cfa_offset 8
; 	.cfi_offset 5, -8
; 	movl	%esp, %ebp
; 	.cfi_def_cfa_register 5
; 	subl	$16, %esp
; 	call	__x86.get_pc_thunk.ax
; 	addl	$_GLOBAL_OFFSET_TABLE_, %eax
; 	movl	8(%ebp), %eax
; 	movl	%eax, -12(%ebp)
; 	movl	$0, -8(%ebp)
; 	movl	$0, -4(%ebp)
; 	jmp	.L2
; .L3:
; 	movl	-12(%ebp), %eax
; 	addl	%eax, -8(%ebp)
; 	movl	-8(%ebp), %eax
; 	addl	%eax, -4(%ebp)
; 	addl	$1, -12(%ebp)
; .L2:
; 	movl	-12(%ebp), %eax
; 	cmpl	12(%ebp), %eax
; 	jle	.L3
; 	movl	-4(%ebp), %eax
; 	leave
; 	.cfi_restore 5
; 	.cfi_def_cfa 4, 4
; 	ret
; 	.cfi_endproc
; .LFE0:
; 	.size	sumOfSumsAtoB, .-sumOfSumsAtoB
; 	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
; 	.globl	__x86.get_pc_thunk.ax
; 	.hidden	__x86.get_pc_thunk.ax
; 	.type	__x86.get_pc_thunk.ax, @function
; __x86.get_pc_thunk.ax:
; .LFB1:
; 	.cfi_startproc
; 	movl	(%esp), %eax
; 	ret
; 	.cfi_endproc
; .LFE1:
; 	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
; 	.section	.note.GNU-stack,"",@progbits
