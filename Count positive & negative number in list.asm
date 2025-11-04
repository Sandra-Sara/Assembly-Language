global main
extern printf
extern scanf
extern exit

section .data
in_fmt      db "%d", 0
prompt_n    db "Enter number of elements: ", 0
prompt_arr  db "Enter the elements: ", 0
out_fmt     db "Positive = %d, Negative = %d", 10, 0

section .bss
n       resd 1          ; number of elements
arr     resd 100        ; array (up to 100 elements)
pos_cnt resd 1
neg_cnt resd 1

section .text

; ===================================================
; main function (no separate function used)
; ===================================================
main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Read number of elements ---
    lea rdi, [rel prompt_n]
    xor eax, eax
    call printf

    lea rdi, [rel in_fmt]
    lea rsi, [rel n]
    xor eax, eax
    call scanf

    ; --- Read array elements ---
    lea rdi, [rel prompt_arr]
    xor eax, eax
    call printf

    mov ecx, 0                   ; index = 0
    mov eax, [n]                 ; eax = n
.read_loop:
    cmp ecx, eax
    jge .count                   ; if index >= n, jump

    lea rdi, [rel in_fmt]
    lea rsi, [rel arr + rcx*4]
    xor eax, eax
    call scanf

    inc ecx
    jmp .read_loop

; --- Count positive and negative numbers ---
.count:
    mov dword [pos_cnt], 0
    mov dword [neg_cnt], 0
    mov ecx, 0                   ; index = 0
    mov eax, [n]                 ; eax = n
.loop:
    cmp ecx, eax
    jge .print_result

    mov edx, [arr + rcx*4]       ; edx = arr[i]
    cmp edx, 0
    jg .is_pos
    jl .is_neg
    jmp .next

.is_pos:
    inc dword [pos_cnt]
    jmp .next

.is_neg:
    inc dword [neg_cnt]
    jmp .next

.next:
    inc ecx
    jmp .loop

; --- Print result ---
.print_result:
    mov eax, [pos_cnt]
    mov esi, eax
    mov eax, [neg_cnt]
    mov edx, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Exit program ---
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit
