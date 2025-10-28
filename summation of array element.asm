global main
extern printf
extern scanf
extern exit

section .data
    prompt_n     db "Enter number of elements: ", 0
    prompt_elem  db "Enter element: ", 0
    scan_fmt     db "%d", 0
    out_fmt      db "Sum of array elements = %d", 10, 0

section .bss
    n       resd 1           ; number of elements
    i       resd 1           ; loop counter
    sum     resd 1           ; sum
    elem    resd 1           ; temporary element

section .text
main:
    ; --- Setup stack frame and align stack ---
    push    rbp
    mov     rbp, rsp
    and     rsp, -16

    ; --- Input number of elements ---
    lea     rdi, [rel prompt_n]
    xor     eax, eax
    call    printf

    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel n]
    xor     eax, eax
    call    scanf

    ; --- Initialize sum = 0, i = 0 ---
    mov     dword [rel sum], 0
    mov     dword [rel i], 0

.loop_start:
    ; if i >= n, break
    mov     eax, dword [rel i]
    cmp     eax, dword [rel n]
    jge     .done

    ; Prompt for element
    lea     rdi, [rel prompt_elem]
    xor     eax, eax
    call    printf

    ; Read element into elem
    lea     rdi, [rel scan_fmt]
    lea     rsi, [rel elem]
    xor     eax, eax
    call    scanf

    ; sum += elem
    mov     eax, dword [rel sum]
    add     eax, dword [rel elem]
    mov     dword [rel sum], eax

    ; i++
    inc dword [rel i]
    jmp .loop_start

.done:
    ; Print sum
    mov     eax, dword [rel sum]
    mov     esi, eax
    lea     rdi, [rel out_fmt]
    xor     eax, eax
    call    printf

    ; Exit
    mov     rsp, rbp
    pop     rbp
    xor     edi, edi
    call    exit
