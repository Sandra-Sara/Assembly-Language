global main
extern printf
extern scanf
extern exit

section .data
in_fmt      db "%d",0
prompt_n    db "Enter number of elements: ",0
prompt_arr  db "Enter the elements: ",0
out_even    db "Even numbers: ",0
out_odd     db "Odd numbers: ",0
space       db " ",0
newline     db 10,0

section .bss
n       resd 1
arr     resd 100
even_cnt resd 1
odd_cnt  resd 1

section .text

main:
    push rbp
    mov rbp,rsp
    and rsp,-16

    ; --- Read number of elements ---
    lea rdi,[rel prompt_n]
    xor eax,eax
    call printf

    lea rdi,[rel in_fmt]
    lea rsi,[rel n]
    xor eax,eax
    call scanf

    ; --- Read array elements ---
    lea rdi,[rel prompt_arr]
    xor eax,eax
    call printf

    mov ecx,0
    mov eax,[n]
.read_loop:
    cmp ecx,eax
    jge .process
    lea rdi,[rel in_fmt]
    lea rsi,[rel arr + rcx*4]
    xor eax,eax
    call scanf
    inc ecx
    jmp .read_loop

; --- Initialize counts ---
.process:
    mov dword [even_cnt],0
    mov dword [odd_cnt],0

    mov ecx,0
    mov eax,[n]
    ; --- Print Even numbers ---
    lea rdi,[rel out_even]
    xor eax,eax
    call printf

.print_even_loop:
    cmp ecx,eax
    jge .print_odd
    mov edx,[arr + rcx*4]
    test edx,1
    jne .next_even
    ; print even number
    mov esi,edx
    lea rdi,[rel space]
    xor eax,eax
    call printf
    mov esi,edx
    lea rdi,[rel in_fmt]     ; temporary reuse
    xor eax,eax
    ; actually better to print number
    lea rdi,[rel out_even]   ; can't reuse out_even; use printf with number
    mov esi,edx
    lea rdi,[rel in_fmt]     ; use "%d"
    mov eax,0
    call printf

.next_even:
    inc ecx
    jmp .print_even_loop

; --- Print Odd numbers ---
.print_odd:
    ; newline
    lea rdi,[rel newline]
    xor eax,eax
    call printf

    lea rdi,[rel out_odd]
    xor eax,eax
    call printf

    mov ecx,0
.print_odd_loop:
    cmp ecx,eax
    jge .done
    mov edx,[arr + rcx*4]
    test edx,1
    je .next_odd
    ; print odd number
    mov esi,edx
    lea rdi,[rel in_fmt]    ; "%d"
    xor eax,eax
    call printf

.next_odd:
    inc ecx
    jmp .print_odd_loop

.done:
    ; newline at end
    lea rdi,[rel newline]
    xor eax,eax
    call printf

    mov rsp,rbp
    pop rbp
    xor edi,edi
    call exit
