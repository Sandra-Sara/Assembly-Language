global main
extern printf
extern scanf
extern exit

section .data
    in_fmt   db "%d", 0
    out_fmt  db "Sum = %d", 10, 0

section .bss
    a   resd 1
    b   resd 1
    res resd 1

section .text
main:
    ; --- Function prologue ---
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Read first number ---
    lea rdi, [rel in_fmt]
    lea rsi, [rel a]
    xor eax, eax
    call scanf

    ; --- Read second number ---
    lea rdi, [rel in_fmt]
    lea rsi, [rel b]
    xor eax, eax
    call scanf

    ; --- Load arguments for sum(a, b) ---
    mov eax, [rel a]
    mov esi, [rel b]
    mov edi, eax          ; edi = first argument
    mov esi, esi          ; esi = second argument
    call sum              ; call function sum(a, b)
    mov [rel res], eax    ; store returned value

    ; --- Print result ---
    mov esi, [rel res]
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Exit program ---
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit


; =======================================
; Function: sum
; Description: returns (a + b)
; Parameters:
;   edi = a
;   esi = b
; Return:
;   eax = result
; =======================================
sum:
    push rbp
    mov rbp, rsp

    mov eax, edi       ; eax = a
    add eax, esi       ; eax = a + b

    pop rbp
    ret

