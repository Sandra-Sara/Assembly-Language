global main
extern printf
extern scanf
extern exit

section .data
msg_in    db "Enter number of elements: ",0
in_fmt    db "%d",0
out_fmt   db "%d ",0
newline   db 10,0

section .bss
n     resd 1
arr   resd 100        ; reserve space for up to 100 integers

section .text

main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Ask user for array size ---
    lea rdi, [rel msg_in]
    xor eax, eax
    call printf

    lea rdi, [rel in_fmt]
    lea rsi, [rel n]
    xor eax, eax
    call scanf

    ; --- Read array elements ---
    mov ecx, 0
.read_loop:
    mov eax, [n]
    cmp ecx, eax
    jge .reverse

    lea rdi, [rel in_fmt]
    lea rsi, [rel arr + rcx*4]
    xor eax, eax
    call scanf

    inc ecx
    jmp .read_loop

.reverse:
    ; --- Print reversed array ---
    mov eax, [n]
    dec eax                ; index = n - 1
.print_reverse:
    cmp eax, -1
    jl .done

    mov esi, [arr + rax*4]
    lea rdi, [rel out_fmt]
    xor edx, edx
    xor eax, eax
    call printf

    dec eax
    jmp .print_reverse

.done:
    lea rdi, [rel newline]
    xor eax, eax
    call printf

    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit


Using function 
global main
extern printf
extern scanf
extern exit

section .data
msg_in    db "Enter number of elements: ",0
msg_arr   db "Enter array elements: ",0
msg_out   db "Reversed array: ",0
in_fmt    db "%d",0
out_fmt   db "%d ",0
newline   db 10,0

section .bss
n     resd 1
arr   resd 100

section .text
main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    lea rdi, [rel msg_in]
    xor eax, eax
    call printf

    lea rdi, [rel in_fmt]
    lea rsi, [rel n]
    xor eax, eax
    call scanf

    lea rdi, [rel msg_arr]
    xor eax, eax
    call printf

    mov ecx, 0
.read_loop:
    mov eax, [n]
    cmp ecx, eax
    jge .call_reverse
    lea rdi, [rel in_fmt]
    lea rsi, [rel arr + rcx*4]
    xor eax, eax
    call scanf
    inc ecx
    jmp .read_loop

.call_reverse:
    lea rdi, [rel arr]
    mov eax, [n]
    mov esi, eax
    call reverse_array

    lea rdi, [rel msg_out]
    xor eax, eax
    call printf

    mov ecx, 0
.print_loop:
    mov eax, [n]
    cmp ecx, eax
    jge .done
    mov esi, [arr + rcx*4]
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf
    inc ecx
    jmp .print_loop

.done:
    lea rdi, [rel newline]
    xor eax, eax
    call printf
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit

reverse_array:
    push rbp
    mov rbp, rsp
    push rbx
    mov ecx, 0
    mov eax, esi
    dec eax
.loop:
    cmp ecx, eax
    jge .done_rev
    mov ebx, [rdi + rcx*4]
    mov edx, [rdi + rax*4]
    mov [rdi + rcx*4], edx
    mov [rdi + rax*4], ebx
    inc ecx
    dec eax
    jmp .loop

.done_rev:
    pop rbx
    pop rbp
    ret