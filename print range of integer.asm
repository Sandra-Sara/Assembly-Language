global main
extern printf
extern scanf
extern exit

section .data
    prompt    db "Enter the limit: ", 0
    scan_fmt  db "%d", 0
    out_fmt   db "%d", 10, 0   ; "%d\n"

section .bss
    n       resd 1             ; counter
    limit   resd 1             ; user-defined limit

section .text
main:
    ; --- Setup stack frame and align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; printf("Enter the limit: ")
    lea     rdi, [rel prompt]
    xor     eax, eax
    call    printf

    ; scanf("%d", &limit)
    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel limit]
    xor     eax, eax
    call    scanf

    ; n = 1
    mov     dword [rel n], 1

.loop_start:
    ; if (n > limit) break;
    mov     eax, dword [rel n]
    cmp     eax, dword [rel limit]
    jg      .done

    ; printf("%d\n", n);
    mov     esi, eax             ; 2nd arg = n
    lea     rdi, [rel out_fmt]   ; 1st arg = "%d\n"
    xor     eax, eax
    call    printf

    ; n++
    inc     dword [rel n]
    jmp     .loop_start

.done:
    ; return 0
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
