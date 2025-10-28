global main
extern printf
extern exit

section .data
    out_fmt db "%X ", 0     ; Print in uppercase hex with space
    nl_fmt  db 10, 0        ; Newline

section .text
main:
    ; --- Align stack to 16 bytes before calling C functions ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16          ; align stack for calls

    xor     ecx, ecx          ; counter i = 0

.print_loop:
    cmp     ecx, 16           ; while (i < 16)
    jge     .done

    ; printf("%X ", i)
    mov     esi, ecx          ; 2nd argument = number to print
    lea     rdi, [rel out_fmt] ; 1st argument = format string
    xor     eax, eax          ; varargs call → rax = 0
    call    printf

    inc     ecx               ; i++
    jmp     .print_loop

.done:
    ; print newline
    lea     rdi, [rel nl_fmt]
    xor     eax, eax
    call    printf

    ; restore stack and exit(0)
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
