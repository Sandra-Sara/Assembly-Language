global main
extern printf
extern exit

section .data
    pos_msg db "The number is positive", 10, 0
    neg_msg db "The number is negative", 10, 0

section .bss
    n   resd 1

section .text
main:
    ; --- Setup stack frame and align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; n = 10
    mov     dword [rel n], 10

    ; Load n into eax
    mov     eax, dword [rel n]

    ; if (n >= 0)
    cmp     eax, 0
    jl      .negative          ; jump if n < 0

.positive:
    ; printf("The number is positive\n");
    lea     rdi, [rel pos_msg]
    xor     eax, eax
    call    printf
    jmp     .done

.negative:
    ; printf("The number is negative\n");
    lea     rdi, [rel neg_msg]
    xor     eax, eax
    call    printf

.done:
    ; return 0
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
