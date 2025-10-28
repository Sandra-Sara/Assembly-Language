global main
extern printf
extern exit

section .data
    out_fmt db "%X ", 0     ; Print in uppercase hex with a space
    nl_fmt  db 10, 0        ; Newline at the end

section .text
main:
    ; --- Align stack to 16 bytes before calling C functions ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    mov     ecx, 0x98        ; Start value = 0x98
.print_loop:
    cmp     ecx, 0xA5        ; While ecx <= 0xA5
    jg      .done

    ; printf("%X ", ecx)
    mov     esi, ecx          ; 2nd argument: number to print
    lea     rdi, [rel out_fmt] ; 1st argument: format string
    xor     eax, eax          ; rax = 0 before varargs call
    call    printf

    inc     ecx               ; ecx++
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
