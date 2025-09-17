Task 3:maximum number among 3 numbers
global main
extern scanf
extern printf
extern exit

section .data
    in_fmt      db "%d %d %d", 0
    out_fmt     db "Maximum = %d", 10, 0

section .bss
    a   resd 1
    b   resd 1
    c   resd 1

section .text
main:
    ; --- Align stack to 16 bytes before calling C functions ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16          ; align stack

    ; scanf("%d %d %d", &a, &b, &c)
    lea     rdi, [rel in_fmt]
    lea     rsi, [rel a]
    lea     rdx, [rel b]
    lea     rcx, [rel c]
    xor     rax, rax
    call    scanf

    ; load numbers into registers
    mov     eax, dword [rel a]   ; eax = a
    mov     ebx, dword [rel b]   ; ebx = b
    mov     ecx, dword [rel c]   ; ecx = c

    ; compare a and b
    cmp     eax, ebx
    jge     .ab_done
    mov     eax, ebx
.ab_done:
    ; compare max(a,b) with c
    cmp     eax, ecx
    jge     .max_done
    mov     eax, ecx
.max_done:

    ; printf("Maximum = %d\n", max)
    mov     esi, eax
    lea     rdi, [rel out_fmt]
    xor     rax, rax
    call    printf

    ; restore stack and exit
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit

Run by using this

nasm -f elf64 max.asm -o max.o
gcc -no-pie -o max max.o
./max
