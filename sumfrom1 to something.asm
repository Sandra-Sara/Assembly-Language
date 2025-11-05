extern printf
extern scanf

SECTION .data
x: dq 0
sum: dq 0

enter: db "Enter a positive number: ",0
out_fmt: db "Sum from 1 to %ld = %ld",10,0
in_fmt: db "%d",0

SECTION .text
global main
main:
        push rbp

        ; Prompt
        mov rax,0
        mov rdi, enter
        call printf

        ; scan x
        mov rax,0
        mov rdi,in_fmt
        mov rsi,x
        call scanf

        ; Initialize
        mov rcx,1        ; counter i = 1
        mov rax,0        ; rax = sum = 0

loop_start:
        cmp rcx,[x]      ; while (i <= x)?
        jg loop_end

        add rax,rcx      ; sum += i
        inc rcx          ; i++
        jmp loop_start

loop_end:
        mov [sum],rax    ; save sum

        ; Print result
        mov rdi,out_fmt
        mov rsi,[x]
        mov rdx,[sum]
        mov rax,0
        call printf

        ; Exit
        pop rbp
        mov rax,0
        ret
