section .data
    prompt_name db "Enter student name: ", 0
    prompt_name_len equ $ - prompt_name
    prompt_score1 db "Enter score 1: ", 0
    prompt_score1_len equ $ - prompt_score1
    prompt_score2 db "Enter score 2: ", 0
    prompt_score2_len equ $ - prompt_score2
    prompt_score3 db "Enter score 3: ", 0
    prompt_score3_len equ $ - prompt_score3
    output_name db "Name: ", 0
    output_name_len equ $ - output_name
    output_avg db "Average: ", 0
    output_avg_len equ $ - output_avg
    output_grade db "Grade: ", 0
    output_grade_len equ $ - output_grade
    grade_p db "P", 10, 0
    grade_f db "F", 10, 0
    newline db 10
    decimal_point db ".", 0

section .bss
    name resb 100
    score1 resb 10
    score2 resb 10
    score3 resb 10
    temp resb 10
    avg_int resb 10
    avg_dec resb 10

section .text
    global main

main:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_name
    mov rdx, prompt_name_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, name
    mov rdx, 100
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_score1
    mov rdx, prompt_score1_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, score1
    mov rdx, 10
    syscall
    mov rsi, score1
    call atoi
    mov r12, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_score2
    mov rdx, prompt_score2_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, score2
    mov rdx, 10
    syscall
    mov rsi, score2
    call atoi
    mov r13, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_score3
    mov rdx, prompt_score3_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, score3
    mov rdx, 10
    syscall
    mov rsi, score3
    call atoi
    mov r14, rax
    mov rdi, r12
    mov rsi, r13
    mov rdx, r14
    call compute_average
    mov r15, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output_name
    mov rdx, output_name_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, name
    mov rdx, 100
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, output_avg
    mov rdx, output_avg_len
    syscall
    mov rax, r15
    mov rsi, temp
    call itoa
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 10
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, output_grade
    mov rdx, output_grade_len
    syscall
    cmp r15, 50
    jge .pass
    mov rax, 1
    mov rdi, 1
    mov rsi, grade_f
    mov rdx, 2
    syscall
    jmp .done
.pass:
    mov rax, 1
    mov rdi, 1
    mov rsi, grade_p
    mov rdx, 2
    syscall
.done:
    xor rax, rax
    ret

compute_average:
    add rdi, rsi
    add rdi, rdx
    mov rax, rdi
    xor rdx, rdx
    mov rbx, 3
    div rbx
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
