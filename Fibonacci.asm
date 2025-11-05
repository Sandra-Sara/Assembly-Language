global main
extern printf
extern scanf
extern exit

section .data
in_fmt   db "%d",0
out_fmt  db "%d ",0
msg_in   db "Enter number of terms: ",0
newline  db 10,0

section .bss
n   resd 1
a   resd 1
b   resd 1
c   resd 1

section .text

main:
    push rbp
    mov rbp,rsp
    and rsp,-16

    ; --- Prompt user ---
    lea rdi,[rel msg_in]
    xor eax,eax
    call printf

    ; --- Read number of terms ---
    lea rdi,[rel in_fmt]
    lea rsi,[rel n]
    xor eax,eax
    call scanf

    ; --- Initialize first two Fibonacci numbers ---
    mov dword [a], 0
    mov dword [b], 1

    ; --- Print first two numbers ---
    mov eax, [a]
    mov esi, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    mov eax, [b]
    mov esi, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Loop for remaining terms ---
    mov ecx, 2               ; counter = 2 (already printed first 2)
.loop:
    mov eax, [n]
    cmp ecx, eax
    jge .done

    mov eax, [a]
    add eax, [b]
    mov [c], eax             ; c = a + b

    ; print c
    mov esi, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; update a = b, b = c
    mov eax, [b]
    mov [a], eax
    mov eax, [c]
    mov [b], eax

    inc ecx
    jmp .loop

.done:
    ; newline
    lea rdi, [rel newline]
    xor eax, eax
    call printf

    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit