global main
extern printf
extern scanf
extern exit

section .data
msg_in    db "Enter number of elements: ",0
in_fmt    db "%d",0
out_fmt   db "%d ",0
newline   db 10,0

section .bss
n     resd 1
arr   resd 100        ; reserve space for up to 100 integers

section .text

main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Ask user for array size ---
    lea rdi, [rel msg_in]
    xor eax, eax
    call printf

    lea rdi, [rel in_fmt]
    lea rsi, [rel n]
    xor eax, eax
    call scanf

    ; --- Read array elements ---
    mov ecx, 0
.read_loop:
    mov eax, [n]
    cmp ecx, eax
    jge .reverse

    lea rdi, [rel in_fmt]
    lea rsi, [rel arr + rcx*4]
    xor eax, eax
    call scanf

    inc ecx
    jmp .read_loop

.reverse:
    ; --- Print reversed array ---
    mov eax, [n]
    dec eax                ; index = n - 1
.print_reverse:
    cmp eax, -1
    jl .done

    mov esi, [arr + rax*4]
    lea rdi, [rel out_fmt]
    xor edx, edx
    xor eax, eax
    call printf

    dec eax
    jmp .print_reverse

.done:
    lea rdi, [rel newline]
    xor eax, eax
    call printf

    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit