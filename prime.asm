global main
extern scanf
extern printf
extern exit

section .data
    in_fmt      db "%d", 0
    out_prime   db "%d is a prime number", 10, 0
    out_notprime db "%d is not a prime number", 10, 0

section .bss
    n   resd 1

section .text
main:
    ; --- Align stack to 16 bytes before calling C functions ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16          ; align stack

    ; scanf("%d", &n)
    lea     rdi, [rel in_fmt]
    lea     rsi, [rel n]
    xor     rax, rax
    call    scanf

    ; load number into eax
    mov     eax, dword [rel n]
    cmp     eax, 2
    jb      .not_prime        ; numbers < 2 are not prime
    je      .is_prime         ; 2 is prime

    ; check divisibility from 2 to sqrt(n)
    mov     ecx, 2            ; divisor = 2
.sqrt_loop:
    mov     edx, 0
    mov     ebx, ecx
    div     ebx               ; eax / ecx → quotient in eax, remainder in edx
    mov     eax, dword [rel n] ; restore eax = n
    test    edx, edx
    je      .not_prime        ; divisible → not prime

    inc     ecx
    mov     ebx, eax
    mov     eax, ecx
    imul    eax, eax
    cmp     eax, dword [rel n]
    jbe     .sqrt_loop         ; loop while divisor^2 <= n

.is_prime:
    ; printf("%d is a prime number\n", n)
    mov     esi, dword [rel n]
    lea     rdi, [rel out_prime]
    xor     rax, rax
    call    printf
    jmp     .exit

.not_prime:
    ; printf("%d is not a prime number\n", n)
    mov     esi, dword [rel n]
    lea     rdi, [rel out_notprime]
    xor     rax, rax
    call    printf

.exit:
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
    
Run by using this

nasm -f elf64 prime.asm -o prime.o
gcc -no-pie -o prime prime.o
./prime
