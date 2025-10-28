global main
extern printf
extern scanf
extern exit

section .data
    in_fmt1     db "Please enter a number: ", 0
    in_fmt2     db "Please enter another number: ", 0
    scan_fmt    db "%d", 0
    sum_fmt     db "%d + %d = %d", 10, 0
    sub_fmt     db "%d - %d = %d", 10, 0
    mul_fmt     db "%d * %d = %d", 10, 0
    div_fmt     db "%d / %d = %d", 10, 0

section .bss
    num1    resd 1
    num2    resd 1

section .text
main:
    ; --- Setup stack frame and align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; printf("Please enter a number: ")
    lea     rdi, [rel in_fmt1]
    xor     eax, eax
    call    printf

    ; scanf("%d", &num1)
    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel num1]
    xor     eax, eax
    call    scanf

    ; printf("Please enter another number: ")
    lea     rdi, [rel in_fmt2]
    xor     eax, eax
    call    printf

    ; scanf("%d", &num2)
    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel num2]
    xor     eax, eax
    call    scanf

    ; Load the numbers into registers
    mov     eax, dword [rel num1]
    mov     ebx, dword [rel num2]

    ; --- Sum ---
    mov     ecx, eax
    add     ecx, ebx
    mov     esi, dword [rel num1]  ; num1
    mov     edx, dword [rel num2]  ; num2
    mov     r8d, ecx               ; result
    lea     rdi, [rel sum_fmt]
    xor     eax, eax
    call    printf

    ; --- Subtraction ---
    mov     eax, dword [rel num1]
    mov     ebx, dword [rel num2]
    sub     eax, ebx
    mov     esi, dword [rel num1]
    mov     edx, dword [rel num2]
    mov     r8d, eax
    lea     rdi, [rel sub_fmt]
    xor     eax, eax
    call    printf

    ; --- Multiplication ---
    mov     eax, dword [rel num1]
    mov     ebx, dword [rel num2]
    imul    eax, ebx
    mov     esi, dword [rel num1]
    mov     edx, dword [rel num2]
    mov     r8d, eax
    lea     rdi, [rel mul_fmt]
    xor     eax, eax
    call    printf

    ; --- Division ---
    mov     eax, dword [rel num1]
    mov     ebx, dword [rel num2]
    cdq                      ; sign extend EAX into EDX:EAX
    idiv    ebx               ; EAX = quotient
    mov     esi, dword [rel num1]
    mov     edx, dword [rel num2]
    mov     r8d, eax
    lea     rdi, [rel div_fmt]
    xor     eax, eax
    call    printf

    ; --- Exit ---
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
