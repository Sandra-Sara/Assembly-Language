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

; ===================================================
; main function
; ===================================================
main:
    push rbp                ; Save base pointer
    mov  rbp, rsp           ; Establish new stack frame
    and  rsp, -16           ; Align stack to 16 bytes

    ; --- Read first integer ---
    lea  rdi, [rel in_fmt]  ; format string
    lea  rsi, [rel a]       ; address of a
    xor  eax, eax
    call scanf

    ; --- Read second integer ---
    lea  rdi, [rel in_fmt]
    lea  rsi, [rel b]
    xor  eax, eax
    call scanf

    ; --- Call max_of_two(a, b) ---
    mov  edi, [rel a]       ; first argument (a)
    mov  esi, [rel b]       ; second argument (b)
    call max_of_two         ; result returned in eax
    mov  [rel max], eax     ; store result

    ; --- Print result ---
    mov  esi, [rel max]     ; 2nd printf argument (value)
    lea  rdi, [rel out_fmt] ; 1st printf argument (format)
    xor  eax, eax
    call printf

    ; --- Exit program ---
    mov  rsp, rbp
    pop  rbp
    xor  edi, edi
    call exit


; ===================================================
; Function: max_of_two
; Purpose : Return the larger of two integers
; Arguments:
;   edi = a
;   esi = b
; Return:
;   eax = max(a, b)
; ===================================================
max_of_two:
    push rbp                ; Save base pointer
    mov  rbp, rsp           ; Establish new stack frame

    mov  eax, edi           ; eax = a
    cmp  esi, eax           ; compare b with a
    jle  .done              ; if b <= a, keep a
    mov  eax, esi           ; else eax = b

.done:
    pop  rbp                ; Restore caller's frame pointer
    ret                     ; Return to caller

