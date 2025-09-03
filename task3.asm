extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
c: dq 0
result: dq 0

enter: db "Enter three numbers: ",0
out_fmt: db "2*%ld + 3*%ld + %ld = %ld", 10, 0
in_fmt: db "%d",0

SECTION .text
global main
main:
        push rbp

        ; Prompt
        mov rax,0
        mov rdi, enter
        call printf

        ; scan a
        mov rax,0
        mov rdi,in_fmt
        mov rsi,a
        call scanf

        ; scan b
        mov rax,0
        mov rdi,in_fmt
        mov rsi,b
        call scanf

        ; scan c
        mov rax,0
        mov rdi,in_fmt
        mov rsi,c
        call scanf

        ; Calculate result = 2a + 3b + c
        mov rax,[a]      ; rax = a
        add rax,[a]      ; rax = a+a = 2a

        mov rbx,[b]      ; rbx = b
        imul rbx,3       ; rbx = 3b
        add rax,rbx      ; rax = 2a + 3b

        add rax,[c]      ; rax = 2a + 3b + c
        mov [result],rax ; save result

        ; Print output
        mov rdi,out_fmt
        mov rsi,[a]
        mov rdx,[b]
        mov rcx,[c]
        mov r8,[result]
        mov rax,0
        call printf

        ; Exit
        pop rbp
        mov rax,0
        ret
