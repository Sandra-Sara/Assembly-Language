global main
extern scanf
extern printf
extern exit

section .data
    in_fmt     db "%d", 0
    out_fmt    db "%d x %d = %d", 10, 0

section .bss
    n       resd 1
    i       resd 1
    res     resd 1

section .text
main:
    ; --- Prologue & align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; scanf("%d", &n)
    lea     rdi, [rel in_fmt]
    lea     rsi, [rel n]
    xor     rax, rax
    call    scanf

    ; i = 1
    mov     dword [rel i], 1

.loop_start:
    ; if (i > 10) break
    mov     eax, dword [rel i]
    cmp     eax, 10
    jg      .done

    ; res = n * i
    mov     eax, dword [rel n]
    imul    eax, dword [rel i]
    mov     dword [rel res], eax

    ; printf("%d x %d = %d\n", n, i, res)
    mov     eax, dword [rel n]     ; 2nd arg
    mov     esi, eax
    mov     eax, dword [rel i]     ; 3rd arg
    mov     edx, eax
    mov     eax, dword [rel res]   ; 4th arg
    mov     ecx, eax
    lea     rdi, [rel out_fmt]     ; format string
    xor     rax, rax
    call    printf

    ; i++
    add     dword [rel i], 1
    jmp     .loop_start

.done:
    ; exit(0)
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit

