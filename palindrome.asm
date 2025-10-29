global main
extern printf
extern scanf
extern exit

section .data
in_str_fmt:     db "%s", 0
out_str_fmt:    db "%s", 10, 0
msg_palindrome: db "Palindrome", 0
msg_not_pal:    db "Not palindrome", 0

section .bss
str:    resb 100
copy:   resb 100

section .text
main:
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; --- Input string ---
    lea     rdi, [rel in_str_fmt]
    lea     rsi, [rel str]
    xor     rax, rax
    call    scanf

    ; --- Copy string ---
    lea     rsi, [rel str]
    lea     rdi, [rel copy]
    call    str_copy

    ; --- Convert to uppercase ---
    lea     rsi, [rel copy]
    call    to_upper

    ; --- Check palindrome ---
    lea     rsi, [rel copy]
    call    is_palindrome

    ; --- Print result ---
    cmp     rax, 0
    je      .not_pal

    lea     rdi, [rel out_str_fmt]
    lea     rsi, [rel msg_palindrome]
    xor     rax, rax
    call    printf
    jmp     .done

.not_pal:
    lea     rdi, [rel out_str_fmt]
    lea     rsi, [rel msg_not_pal]
    xor     rax, rax
    call    printf

.done:
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit


; ------------------------------------------------
; str_len: count characters in string
; Input:  rsi -> string
; Output: rcx = length
; ------------------------------------------------
str_len:
    push rax
    mov rcx, 0
.loop_len:
    mov al, [rsi + rcx]
    cmp al, 0
    je  .done
    inc rcx
    jmp .loop_len
.done:
    pop rax
    ret


; ------------------------------------------------
; str_copy: copy string from [rsi] → [rdi]
; ------------------------------------------------
str_copy:
    push rcx
    call str_len
    mov rdx, rcx
.loop_copy:
    cmp rdx, 0
    jl .done
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rdx
    jmp .loop_copy
.done:
    mov byte [rdi], 0
    pop rcx
    ret


; ------------------------------------------------
; to_upper: convert lowercase letters to uppercase
; ------------------------------------------------
to_upper:
    push rcx
    call str_len
    mov rdx, rcx
    mov rcx, 0
.loop_up:
    cmp rcx, rdx
    jge .done
    mov al, [rsi + rcx]
    cmp al, 'a'
    jb  .next
    cmp al, 'z'
    ja  .next
    sub al, 32
    mov [rsi + rcx], al
.next:
    inc rcx
    jmp .loop_up
.done:
    pop rcx
    ret


; ------------------------------------------------
; is_palindrome: check if string is palindrome
; Input:  rsi -> string
; Output: rax = 1 if palindrome, 0 otherwise
; ------------------------------------------------
is_palindrome:
    push rcx
    push rdx
    call str_len
    mov rdx, 0
    dec rcx
.loop_check:
    cmp rdx, rcx
    jge .palindrome
    mov al, [rsi + rdx]
    mov ah, [rsi + rcx]
    cmp al, ah
    jne .not_palindrome
    inc rdx
    dec rcx
    jmp .loop_check

.palindrome:
    mov rax, 1
    jmp .done

.not_palindrome:
    mov rax, 0

.done:
    pop rdx
    pop rcx
    ret

