section .data
    prompt_rows db "Enter number of rows: ", 0
    prompt_rows_len equ $ - prompt_rows
    prompt_cols db "Enter number of columns: ", 0
    prompt_cols_len equ $ - prompt_cols
    prompt_mat1 db "Enter first matrix elements (0 or 1):", 10, 0
    prompt_mat1_len equ $ - prompt_mat1
    prompt_mat2 db "Enter second matrix elements (0 or 1):", 10, 0
    prompt_mat2_len equ $ - prompt_mat2
    result_msg db "Result matrix after AND operation:", 10, 0
    result_msg_len equ $ - result_msg
    newline db 10
    space db " ", 0

section .bss
    rows resb 10
    cols resb 10
    matrix1 resb 100
    matrix2 resb 100
    result resb 100
    temp resb 10
    row_count resb 8
    col_count resb 8
    total_elements resb 8

section .text
    global main

main:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_rows
    mov rdx, prompt_rows_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, rows
    mov rdx, 10
    syscall
    mov rsi, rows
    call atoi
    mov [row_count], rax
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_cols
    mov rdx, prompt_cols_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, cols
    mov rdx, 10
    syscall
    mov rsi, cols
    call atoi
    mov [col_count], rax
    mov rax, [row_count]
    imul rax, [col_count]
    mov [total_elements], rax
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_mat1
    mov rdx, prompt_mat1_len
    syscall
    mov rsi, matrix1
    mov rcx, [total_elements]
    call read_matrix
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_mat2
    mov rdx, prompt_mat2_len
    syscall
    mov rsi, matrix2
    mov rcx, [total_elements]
    call read_matrix
    mov rdi, matrix1
    mov rsi, matrix2
    mov rdx, result
    mov rcx, [total_elements]
    call matrix_and
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall
    mov rsi, result
    mov rcx, [row_count]
    mov rdx, [col_count]
    call print_matrix
    xor rax, rax
    ret

read_matrix:
    push rbx
    push rcx
    mov rbx, rsi
.read_loop:
    cmp rcx, 0
    je .read_done
    push rcx
    mov rax, 0
    mov rdi, 0
    mov rsi, temp
    mov rdx, 10
    syscall
    push rbx
    mov rsi, temp
    call atoi
    pop rbx
    mov [rbx], al
    inc rbx
    pop rcx
    dec rcx
    jmp .read_loop
.read_done:
    pop rcx
    pop rbx
    ret

matrix_and:
    push rbx
    push rcx
.and_loop:
    cmp rcx, 0
    je .and_done
    movzx rax, byte [rdi]
    movzx rbx, byte [rsi]
    and rax, rbx
    mov [rdx], al
    inc rdi
    inc rsi
    inc rdx
    dec rcx
    jmp .and_loop
.and_done:
    pop rcx
    pop rbx
    ret

print_matrix:
    push rbx
    push rcx
    push rdx
    mov rbx, rsi
    mov r12, rcx
    mov r13, rdx
.print_row_loop:
    cmp r12, 0
    je .print_done
    mov r14, r13
.print_col_loop:
    cmp r14, 0
    je .next_row
    movzx rax, byte [rbx]
    push rbx
    mov rsi, temp
    call itoa
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 10
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    pop rbx
    inc rbx
    dec r14
    jmp .print_col_loop
.next_row:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    dec r12
    jmp .print_row_loop
.print_done:
    pop rdx
    pop rcx
    pop rbx
    ret

atoi:
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx rdx, byte [rsi]
    cmp rdx, 10
    je .done
    cmp rdx, 0
    je .done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rsi
    jmp .loop
.done:
    ret

itoa:
    push rbx
    push rcx
    push rdx
    mov rbx, 10
    xor rcx, rcx
.divide:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .divide
.write:
    pop rax
    mov [rsi], al
    inc rsi
    loop .write
    mov byte [rsi], 0
    pop rdx
    pop rcx
    pop rbx
    ret
