global main
extern scanf
extern printf
extern exit

section .data
    in_fmt     db "%d", 0
    out_fmt    db "Reversed = %d", 10, 0

section .bss
    n       resd 1
    rev     resd 1

section .text
main:
    ; --- Function prologue and stack alignment ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16           ; align stack to 16

    ; scanf("%d", &n)
    lea     rdi, [rel in_fmt]  ; format string
    lea     rsi, [rel n]       ; &n
    xor     rax, rax
    call    scanf

    ; eax = n
    mov     eax, dword [rel n]
    xor     ebx, ebx           ; rev = 0

.reverse_loop:
    cmp     eax, 0             ; while (n != 0)
    je      .done_reverse

    mov     edx, 0
    mov     ecx, 10
    div     ecx                ; eax / 10 -> quotient in eax, remainder in edx

    ; rev = rev * 10 + remainder
    imul    ebx, ebx, 10
    add     ebx, edx

    jmp     .reverse_loop

.done_reverse:
    ; store reversed result
    mov     dword [rel rev], ebx

    ; printf("Reversed = %d\n", rev)
    mov     esi, dword [rel rev]
    lea     rdi, [rel out_fmt]
    xor     rax, rax
    call    printf

    ; exit(0)
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit

