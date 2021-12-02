    .file "asmfuck.S"
    .intel_syntax noprefix

    .text
    .align  16
    .globl  asmfuck_main
    .type   asmfuck_main, @function
asmfuck_main:
    push    rbp
    mov     rbp, rsp
    lea     r8, BYTE PTR [rdi] # Instruction pointer
    mov     r9, 0 # Tape pointer
asmfuck_begin:
    cmp     BYTE PTR [r8], 0
    je      asmfuck_finish
    cmp     BYTE PTR [r8], '+'
    je      asmfuck_incr
    cmp     BYTE PTR [r8], '-'
    je      asmfuck_decr
    cmp     BYTE PTR [r8], '>'
    je      asmfuck_next
    cmp     BYTE PTR [r8], '<'
    je      asmfuck_prev
    cmp     BYTE PTR [r8], '['
    je      asmfuck_loop_begin
    cmp     BYTE PTR [r8], ']'
    je      asmfuck_loop_end
    cmp     BYTE PTR [r8], '.'
    je      asmfuck_write
    cmp     BYTE PTR [r8], ','
    je      asmfuck_read
    jmp     asmfuck_end
asmfuck_incr:
    lea     rcx, _tape[rip]
    add     rcx, r9
    inc     BYTE PTR [rcx]
    jmp     asmfuck_end
asmfuck_decr:
    lea     rcx, _tape[rip]
    add     rcx, r9
    dec     BYTE PTR [rcx]
    jmp     asmfuck_end
asmfuck_next:
    inc     r9
    mov     r11, 0
    cmp     r9, 30000
    cmove   r9, r11
    jmp     asmfuck_end
asmfuck_prev:
    mov     r11, 30000
    cmp     r9, 0
    cmove   r9, r11
    dec     r9
    jmp     asmfuck_end
asmfuck_loop_begin:
    lea     rcx, _tape[rip]
    add     rcx, r9
    cmp     BYTE PTR [rcx], 0
    je      asmfuck_loop_skipper
    push    r8
    jmp     asmfuck_end
asmfuck_loop_skipper:
    mov     rdi, r8
    call    asmfuck_loop_skip
    mov     r8, rax
    jmp     asmfuck_end
asmfuck_loop_end:
    lea     rcx, _tape[rip]
    add     rcx, r9
    pop     r10
    cmp     BYTE PTR [rcx], 0
    je      asmfuck_loop_end_skip
    mov     r8, r10
    push    r8
asmfuck_loop_end_skip:
    jmp     asmfuck_end
asmfuck_write:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, _tape[rip]
    add     rsi, r9
    mov     rdx, 1
    syscall
    jmp     asmfuck_end
asmfuck_read:
    mov     rax, 0
    mov     rdi, 0
    lea     rsi, _tape[rip]
    add     rsi, r9
    mov     rdx, 1
    syscall
asmfuck_end:
    inc     r8
    jmp     asmfuck_begin
asmfuck_finish:
    mov     rsp, rbp
    pop     rbp
    mov     rax, 0
    ret

asmfuck_loop_skip:
    mov     rax, rdi
    inc     rax
    mov     r11, 1
asmfuck_loop_skip_begin:
    cmp     BYTE PTR [rax], ']'
    je      asmfuck_loop_skip_decr
    cmp     BYTE PTR [rax], '['
    je      asmfuck_loop_skip_incr
    jmp     asmfuck_loop_skip_end
asmfuck_loop_skip_incr:
    inc     r11
    jmp     asmfuck_loop_skip_end
asmfuck_loop_skip_decr:
    dec     r11
    jmp     asmfuck_loop_skip_end
asmfuck_loop_skip_end:
    cmp     r11, 0
    je      asmfuck_loop_skip_finish
    inc     rax
    jmp     asmfuck_loop_skip_begin
asmfuck_loop_skip_finish:
    ret

    .section .bss
    .lcomm _tape, 30000
