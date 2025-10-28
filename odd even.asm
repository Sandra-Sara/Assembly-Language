global main
extern printf
extern scanf
extern exit

section .data
    in_msg     db "Enter a number: ", 0
    scan_fmt   db "%d", 0
    even_msg   db "The number is even", 10, 0
    odd_msg    db "The number is odd", 10, 0

section .bss
    number      resd 1
    remainder   resd 1

section .text
main:
    ; --- Setup stack frame and align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; printf("Enter a number: ");
    lea     rdi, [rel in_msg]
    xor     eax, eax
    call    printf

    ; scanf("%d", &number);
    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel number]
    xor     eax, eax
    call    scanf

    ; remainder = number % 2
    mov     eax, dword [rel number]
    mov     ebx, 2
    cdq                     ; sign extend EAX into EDX:EAX
    idiv    ebx              ; EAX = quotient, EDX = remainder
    mov     dword [rel remainder], edx

    ; if (remainder == 0)
    cmp     dword [rel remainder], 0
    jne     .odd             ; jump if remainder != 0

.even:
    ; printf("The number is even\n");
    lea     rdi, [rel even_msg]
    xor     eax, eax
    call    printf
    jmp     .done

.odd:
    ; printf("The number is odd\n");
    lea     rdi, [rel odd_msg]
    xor     eax, eax
    call    printf

.done:
    ; restore stack and exit(0)
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
