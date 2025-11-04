global main
extern printf
extern scanf
extern exit

section .data
in_fmt      db "%d",0
prompt_n    db "Enter number of elements: ",0
prompt_arr  db "Enter the elements: ",0
out_fmt     db "Even = %d, Odd = %d",10,0

section .bss
n       resd 1          ; number of elements
arr     resd 100        ; array (up to 100 integers)
even_cnt resd 1
odd_cnt  resd 1

section .text

main:
    push rbp
    mov rbp, rsp
    and rsp, -16

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
    jge .count_loop

    lea rdi,[rel in_fmt]
    lea rsi,[rel arr + rcx*4]
    xor eax,eax
    call scanf

    inc ecx
    jmp .read_loop

; --- Count even and odd numbers ---
.count_loop:
    mov dword [even_cnt],0
    mov dword [odd_cnt],0
    mov ecx,0
    mov eax,[n]
.loop:
    cmp ecx,eax
    jge .print_result

    mov edx,[arr + rcx*4]     ; edx = arr[i]
    and edx,1                  ; check LSB
    cmp edx,0
    je .is_even
    ; else odd
    inc dword [odd_cnt]
    jmp .next

.is_even:
    inc dword [even_cnt]

.next:
    inc ecx
    jmp .loop

; --- Print results ---
.print_result:
    mov eax,[even_cnt]
    mov esi,eax
    mov eax,[odd_cnt]
    mov edx,eax
    lea rdi,[rel out_fmt]
    xor eax,eax
    call printf

    ; --- Exit ---
    mov rsp,rbp
    pop rbp
    xor edi,edi
    call exit
