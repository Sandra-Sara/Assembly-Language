global main
extern printf
extern scanf
extern exit

section .data
in_fmt  db "%s",0
out_fmt db "Number of vowels = %d",10,0

section .bss
str resb 100         ; input string buffer (max 99 chars + null)
vowel_count resd 1

section .text

; ===================================================
; main function
; ===================================================
main:
    push rbp
    mov rbp, rsp
    and rsp, -16

    ; --- Read input string ---
    lea rdi, [rel in_fmt]
    lea rsi, [rel str]
    xor eax, eax
    call scanf

    ; --- Call count_vowels function ---
    lea rdi, [rel str]
    call count_vowels
    mov [vowel_count], eax

    ; --- Print result ---
    mov eax, [vowel_count]
    mov esi, eax
    lea rdi, [rel out_fmt]
    xor eax, eax
    call printf

    ; --- Exit ---
    mov rsp, rbp
    pop rbp
    xor edi, edi
    call exit

; ===================================================
; Function: count_vowels
; Counts number of vowels (A, E, I, O, U, a, e, i, o, u)
; Argument: rdi = pointer to string
; Return: eax = vowel count
; ===================================================
count_vowels:
    push rbp
    mov rbp, rsp
    push rbx

    mov rsi, rdi       ; rsi = pointer to string
    xor eax, eax       ; eax = vowel count = 0

.next_char:
    mov bl, [rsi]      ; load next character
    cmp bl, 0
    je .done           ; end of string

    ; Check lowercase vowels
    cmp bl, 'a'
    je .inc
    cmp bl, 'e'
    je .inc
    cmp bl, 'i'
    je .inc
    cmp bl, 'o'
    je .inc
    cmp bl, 'u'
    je .inc

    ; Check uppercase vowels
    cmp bl, 'A'
    je .inc
    cmp bl, 'E'
    je .inc
    cmp bl, 'I'
    je .inc
    cmp bl, 'O'
    je .inc
    cmp bl, 'U'
    je .inc

    jmp .next

.inc:
    inc eax
.next:
    inc rsi
    jmp .next_char

.done:
    pop rbx
    pop rbp
    ret
