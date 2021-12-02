    .file "interp.S"
    .intel_syntax noprefix

    .text
    .align  16
    .globl  interp_main
    .type   interp_main, @function
interp_main:
    push    rbp
    mov     rbp, rsp
    lea     r8, BYTE PTR [rdi] # Instruction pointer
    mov     r9, 0 # Tape pointer
interp_begin:
    cmp     BYTE PTR [r8], 0
    je      interp_finish
    cmp     BYTE PTR [r8], '+'
    je      interp_incr
    cmp     BYTE PTR [r8], '-'
    je      interp_decr
    cmp     BYTE PTR [r8], '>'
    je      interp_next
    cmp     BYTE PTR [r8], '<'
    je      interp_prev
    cmp     BYTE PTR [r8], '['
    je      interp_loop_begin
    cmp     BYTE PTR [r8], ']'
    je      interp_loop_end
    cmp     BYTE PTR [r8], '.'
    je      interp_write
    cmp     BYTE PTR [r8], ','
    je      interp_read
    jmp     interp_end
interp_incr:
    lea     rcx, _tape[rip]
    add     rcx, r9
    inc     BYTE PTR [rcx]
    jmp     interp_end
interp_decr:
    lea     rcx, _tape[rip]
    add     rcx, r9
    dec     BYTE PTR [rcx]
    jmp     interp_end
interp_next:
    inc     r9
    mov     r11, 0
    cmp     r9, 30000
    cmove   r9, r11
    jmp     interp_end
interp_prev:
    mov     r11, 30000
    cmp     r9, 0
    cmove   r9, r11
    dec     r9
    jmp     interp_end
interp_loop_begin:
    lea     rcx, _tape[rip]
    add     rcx, r9
    cmp     BYTE PTR [rcx], 0
    je      interp_loop_skipper
    push    r8
    jmp     interp_end
interp_loop_skipper:
    mov     rdi, r8
    call    interp_loop_skip
    mov     r8, rax
    jmp     interp_end
interp_loop_end:
    lea     rcx, _tape[rip]
    add     rcx, r9
    pop     r10
    cmp     BYTE PTR [rcx], 0
    je      interp_loop_end_skip
    mov     r8, r10
    push    r8
interp_loop_end_skip:
    jmp     interp_end
interp_write:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, _tape[rip]
    add     rsi, r9
    mov     rdx, 1
    syscall
    jmp     interp_end
interp_read:
    mov     rax, 0
    mov     rdi, 0
    lea     rsi, _tape[rip]
    add     rsi, r9
    mov     rdx, 1
    syscall
interp_end:
    inc     r8
    jmp     interp_begin
interp_finish:
    mov     rsp, rbp
    pop     rbp
    mov     rax, 0
    ret

interp_loop_skip:
    mov     rax, rdi
    inc     rax
    mov     r11, 1
interp_loop_skip_begin:
    cmp     BYTE PTR [rax], ']'
    je      interp_loop_skip_decr
    cmp     BYTE PTR [rax], '['
    je      interp_loop_skip_incr
    jmp     interp_loop_skip_end
interp_loop_skip_incr:
    inc     r11
    jmp     interp_loop_skip_end
interp_loop_skip_decr:
    dec     r11
    jmp     interp_loop_skip_end
interp_loop_skip_end:
    cmp     r11, 0
    je      interp_loop_skip_finish
    inc     rax
    jmp     interp_loop_skip_begin
interp_loop_skip_finish:
    ret

    .section .bss
    .lcomm _tape, 30000
