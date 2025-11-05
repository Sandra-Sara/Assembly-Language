global main
extern printf
extern scanf
extern exit

section .data
msg_in    db "Enter number of elements: ",0
msg_arr   db "Enter array elements: ",0
msg_out   db "Sorted array (ascending): ",0
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
    jge .call_sort
    lea rdi, [rel in_fmt]
    lea rsi, [rel arr + rcx*4]
    xor eax, eax
    call scanf
    inc ecx
    jmp .read_loop

.call_sort:
    lea rdi, [rel arr]
    mov eax, [n]
    mov esi, eax
    call bubble_sort

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

bubble_sort:
    push rbp
    mov rbp, rsp
    push rbx
    push rdx
    push r8

    mov ecx, esi
    dec ecx
.outer_loop:
    cmp ecx, 0
    jl .done_sort
    mov edx, 0
.inner_loop:
    cmp edx, ecx
    jge .next_pass
    mov eax, [rdi + rdx*4]
    mov ebx, [rdi + rdx*4 + 4]
    cmp eax, ebx
    jle .no_swap
    mov [rdi + rdx*4], ebx
    mov [rdi + rdx*4 + 4], eax
.no_swap:
    inc edx
    jmp .inner_loop
.next_pass:
    dec ecx
    jmp .outer_loop

.done_sort:
    pop r8
    pop rdx
    pop rbx
    pop rbp
    ret
