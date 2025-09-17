global main
extern scanf
extern printf
extern exit

section .data
    in_fmt     db "%d %d", 0
    out_fmt    db "GCD = %d", 10, 0

section .bss
    a   resd 1
    b   resd 1

section .text
main:
    ; --- Align stack to 16 bytes before calling C functions ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16          ; align stack

    ; scanf("%d %d", &a, &b)
    lea     rdi, [rel in_fmt]   ; 1st arg: format string
    lea     rsi, [rel a]        ; 2nd arg: &a
    lea     rdx, [rel b]        ; 3rd arg: &b
    xor     rax, rax            ; varargs call requires rax = 0
    call    scanf

    ; load inputs into registers
    mov     eax, dword [rel a]  ; eax = a
    mov     ebx, dword [rel b]  ; ebx = b

    ; absolute values
    test    eax, eax
    jge     .check_b
    neg     eax
.check_b:
    test    ebx, ebx
    jge     .gcd_start
    neg     ebx

.gcd_start:
    cmp     eax, 0
    jne     .loop_start
    cmp     ebx, 0
    je      .both_zero
    mov     ecx, ebx
    jmp     .print

.loop_start:
    cmp     ebx, 0
    je      .done
.loop:
    mov     edx, 0
    div     ebx          ; eax/ebx → eax=quotient, edx=remainder
    mov     eax, ebx     ; a = b
    mov     ebx, edx     ; b = remainder
    cmp     ebx, 0
    jne     .loop
.done:
    mov     ecx, eax     ; result in ecx
    jmp     .print

.both_zero:
    xor     ecx, ecx     ; gcd(0,0) = 0

.print:
    ; printf("GCD = %d\n", result)
    mov     esi, ecx     ; 2nd arg = result
    lea     rdi, [rel out_fmt] ; 1st arg = format
    xor     rax, rax
    call    printf

    ; restore stack and exit
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
