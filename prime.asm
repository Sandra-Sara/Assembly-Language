global main
extern scanf
extern printf
extern exit

section .data
    in_fmt       db "%d", 0
    out_prime    db "%d is a prime number", 10, 0
    out_notprime db "%d is not a prime number", 10, 0

section .bss
    n   resd 1

section .text
main:
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; scanf("%d", &n)
    lea     rdi, [rel in_fmt]
    lea     rsi, [rel n]
    xor     eax, eax
    call    scanf

    mov     eax, [n]
    cmp     eax, 2
    jb      .not_prime
    je      .is_prime

    mov     ecx, 2          ; divisor = 2

.sqrt_loop:
    mov     eax, [n]        ; reload n before each division
    cdq                      ; sign-extend EAX → EDX:EAX
    div     ecx              ; EAX / ECX
    test    edx, edx
    je      .not_prime       ; if remainder == 0 → not prime

    inc     ecx
    mov     eax, ecx
    imul    eax, eax
    cmp     eax, [n]
    jbe     .sqrt_loop       ; while (divisor^2 <= n)

.is_prime:
    mov     esi, [n]
    lea     rdi, [rel out_prime]
    xor     eax, eax
    call    printf
    jmp     .exit

.not_prime:
    mov     esi, [n]
    lea     rdi, [rel out_notprime]
    xor     eax, eax
    call    printf

.exit:
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit



nasm -f elf64 prime.asm -o prime.o
gcc -no-pie -o prime prime.o
./prime
