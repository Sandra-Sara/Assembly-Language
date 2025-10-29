extern printf
extern scanf

SECTION .data
in_str_fmt: db "%s",0
out_str_fmt: db "%s",10,0
str: resb 100       ; buffer to store input string
rev_str: resb 100   ; buffer to store reversed string

SECTION .text
global main

main:
    push rbp

    ; read string
    mov rdi, in_str_fmt
    lea rsi, [str]
    xor rax, rax
    call scanf

    ; call reverse_str
    lea rdi, [str]     ; source string
    lea rsi, [rev_str] ; destination string
    call reverse_str

    ; print reversed string
    mov rdi, out_str_fmt
    lea rsi, [rev_str]
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret

; reverse_str: reverses string from rdi to rsi
; rdi = source string, rsi = destination buffer
reverse_str:
    push rbp
    mov rbp, rsp

    mov rdx, rdi       ; save source pointer in rdx
    xor rcx, rcx       ; rcx = length counter

.rev_len:
    mov al, [rdx+rcx]
    cmp al, 0
    je .rev_copy       ; reached end of string
    inc rcx
    jmp .rev_len

.rev_copy:
    dec rcx            ; last valid index
    xor r8, r8         ; r8 = dest index

.rev_loop:
    cmp rcx, -1
    jl .done
    mov al, [rdi+rcx]
    mov [rsi+r8], al
    inc r8
    dec rcx
    jmp .rev_loop

.done:
    mov byte [rsi+r8], 0   ; null terminate
    pop rbp
    ret

