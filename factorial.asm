global main
extern printf
extern scanf
extern exit

section .data
in_fmt  db "%d",0
out_fmt db "Factorial = %d",10,0    ; prints with newline

section .bss
num resd 1
result resd 1

section .text

; ===================================================
; main function
; ===================================================
main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Read input number ---
    lea rdi, [rel in_fmt]
    lea rsi, [rel num]
    xor eax, eax
    call scanf

    ; --- Call factorial function ---
    mov eax, [num]        ; move input number to eax
    mov edi, eax          ; pass as argument (n)
    call factorial
    mov [result], eax     ; store returned value

    ; --- Print result ---
    mov eax, [result]
    mov esi, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Exit ---
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit

; ===================================================
; Function: factorial
; Calculates factorial of a number (n!)
; Argument: edi = number n
; Return: eax = factorial
; ===================================================
factorial:
    push rbp
    mov rbp, rsp
    push rbx

    mov eax, 1        ; result = 1
    mov ecx, edi      ; ecx = n

.loop:
    cmp ecx, 1
    jl .done          ; if n < 1, stop
    imul eax, ecx     ; result *= n
    dec ecx
    jmp .loop

.done:
    pop rbx
    pop rbp
    ret
