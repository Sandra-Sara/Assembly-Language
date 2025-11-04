global main
extern printf
extern scanf
extern exit

section .data
in_fmt      db "%s",0
out_fmt     db "Uppercase: %s",10,0

section .bss
str resb 100       ; input string (max 99 chars + null)

section .text

main:
    push rbp
    mov rbp,rsp
    and rsp,-16

    ; --- Read string ---
    lea rdi,[rel in_fmt]
    lea rsi,[rel str]
    xor eax,eax
    call scanf

    ; --- Convert lowercase letters to uppercase ---
    lea rsi,[rel str]
.convert_loop:
    mov al,[rsi]
    cmp al,0
    je .done_convert
    cmp al,'a'
    jb .next_char
    cmp al,'z'
    ja .next_char
    sub byte [rsi], 32     ; convert to uppercase (ASCII)
.next_char:
    inc rsi
    jmp .convert_loop

.done_convert:
    ; --- Print result ---
    lea rdi,[rel out_fmt]
    lea rsi,[rel str]
    xor eax,eax
    call printf

    ; --- Exit ---
    mov rsp,rbp
    pop rbp
    xor edi,edi
    call exit
