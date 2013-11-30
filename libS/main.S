#
#   hash  <carloslack@gmail.com>
# 
#   Command line parser to feed libS
#
########################

#   Sets current argument index into
#   given register

# Header file for ENTRY (local) macro and others.
.include "main.inc"

.section .rodata
nl: .byte 0xa

.text

.globl _start
_start:
loop:
    xorl %edi, %edi
    NARG %ebx
    cmpl $0, %ebx
    je quit
    GETARG %ecx

    # Here we already have arguments
    pushl %ecx
    call s_log
    addl $4, %esp

    # move to next argument
    SETARG %ecx
    jmp loop

quit:
    
    # %ebx is already set
    movb $1, %al
    int $0x80

