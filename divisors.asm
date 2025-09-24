global main
extern scanf
extern printf
extern exit

section .data
    in_fmt     db "%d", 0
    out_fmt    db "%d ", 0

section .bss
    n   resd 1
    i   resd 1

section .text
main:
    ; --- setup stack frame ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; scanf("%d", &n)
    lea     rdi, [rel in_fmt]
    lea     rsi, [rel n]
    xor     rax, rax
    call    scanf

    ; i = 1
    mov     dword [i], 1

.loop_start:
    ; if i > n → end
    mov     eax, [i]
    mov     ebx, [n]
    cmp     eax, ebx
    jg      .done

    ; check n % i == 0
    mov     eax, [n]
    cdq                     ; sign extend into edx
    idiv    dword [i]       ; eax = n / i, edx = n % i
    cmp     edx, 0
    jne     .next_i         ; if remainder != 0 → skip

    ; printf("%d ", i)
    mov     esi, [i]
    lea     rdi, [rel out_fmt]
    xor     rax, rax
    call    printf

.next_i:
    ; i++
    add     dword [i], 1
    jmp     .loop_start

.done:
    ; exit(0)
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit

