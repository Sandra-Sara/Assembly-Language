global main
extern printf
extern scanf
extern exit

section .data
    in_fmt     db "%d", 0
    out_fmt    db "The larger number is %d", 10, 0

section .bss
    a   resd 1
    b   resd 1
    max resd 1

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

    ; --- Call max_of_two(a, b) ---
    mov edi, [rel a]      ; first argument (in edi)
    mov esi, [rel b]      ; second argument (in esi)
    call max_of_two
    mov [rel max], eax    ; store result

    ; --- Print result ---
    mov esi, [rel max]    ; 2nd argument = max value
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Exit program ---
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit


; =======================================
; Function: max_of_two
; Description: returns the larger of (a, b)
; Parameters:
;   edi = a
;   esi = b
; Return:
;   eax = max(a, b)
; =======================================
max_of_two:
    push rbp
    mov rbp, rsp

    mov eax, edi        ; eax = a
    cmp esi, eax        ; compare b with a
    jle .done           ; if b <= a, keep a
    mov eax, esi        ; else eax = b

.done:
    pop rbp
    ret

