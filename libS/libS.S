/*
 *
 *  hash  <carloslack@gmail.com>
 *
 *  ASM helper library (under construction)
 *
 */

# Header file for ENTRY macro
.include "libS.inc"

.section .rodata
nl: .byte 0xa /* new line */

# syscall numbers
.equ SYS_exit, 1
.equ SYS_read,  3
.equ SYS_write, 4

.text

#
# Debug functions
#

/*  
 *  _sig_:size_t s_log(const char *str);
 *  @in str
 *  @out %eax [number of characters processed]
 */
ENTRY s_log
    pushl %ebp
    movl %esp, %ebp

    xorl %eax, %eax
    movl 8(%esp), %eax

    subl $4, %esp
    
    pushl %eax
    call s_strlen
    movl %eax, -4(%ebp)

    cmpl $0, -4(%ebp)
    je end_s_log

    movl $1, %ebx
    popl %ecx
    movl -4(%ebp), %edx
    movl $SYS_write, %eax
    int $0x80

    movl $1, %ebx
    movl $nl, %ecx
    movl $1, %edx
    movl $SYS_write, %eax
    int $0x80

end_s_log:
    movl -4(%ebp), %eax  
    addl $4, %esp
    leave
    ret

#
# String functions
#

/*
 *  _sig_:size_t s_strlen(const char *str);
 *  @in str
 *  @out %eax [length of given string]
 */
ENTRY s_strlen
    pushl %ebp
    movl %esp, %ebp

    xorl %ecx, %ecx
    xorl %edi, %edi
    movl 8(%esp), %ecx
    leal (%ecx), %esi
    cmpl $0, %ecx
    je endstrlen
count:
    lodsb
    cmp $0, %al
    je endstrlen
    incl %edi
    jmp count
endstrlen:
    movl %edi, %eax
    leave
    ret

/*
 *  _sig_:size_t s_strncmp(const char *s1, const char *s2, size_t n);
 *  @in 8(%esp) [s1]
 *  @in 12(%esp) [s2]
 *  @in 16(%esp) [n]
 *  @out %eax [result]
 */
ENTRY s_strncmp
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %esi
    movl 12(%esp), %edi
    movl 16(%esp), %ecx

    cld
    repe cmpsb
    jz eq
noteq:
    movl $1, %eax
    jmp endstrncmp
eq:
    xorl %eax, %eax
endstrncmp:
    leave
    ret

#
# Number & math & bit functions
#

/*
 *  _sig_:int s_mod(unsigned int x, unsigned int y);
 *  @in 8(%esp) [x]
 *  @in 12(%esp) [y]
 *  @out %ax [remainder]
 */
ENTRY s_mod
    pushl %ebp
    movl %esp, %ebp

    # mod goes here
    xor %dx, %dx
    xorl %eax, %eax
    
    mov 8(%ebp), %ax   
    mov 12(%ebp), %bx   
    div %bx             

    # save return, pad 0
    movzwl %dx, %eax       

    leave
    ret

/*
 *  _sig_:int s_bitscandw(int direction, int dword);
 *  @in 8(%esp) [direction]
 *  @in 12(%esp) [dword]
 *  @out %eax [offset]   
 */
ENTRY s_bitscandw
    pushl %ebp
    movl %esp, %ebp
    
    xorl %edi, %edi

    movl 8(%esp), %edi
    movl 12(%esp), %esi

    # add space
    subl $4, %esp

    # save dword into local storage
    movl %esi, -4(%ebp)

    # will reuse %esi later
    xorl %esi, %esi

    cmpl $bforward, %edi
    je .bsfl
    cmpl $breverse, %edi
    je .bsrl

    # invalid argument
    jmp .unset

.bsfl: # forward
    bsfl -4(%ebp), %esi
    jz .unset
    movl %esi, %eax
    jmp .end

.bsrl: # reverse
    bsrl -4(%ebp), %esi
    jz .unset
    movl %esi, %eax
    jmp .end

# Argument is zero or invalid
.unset:
    movl $-1, %eax
.end:
    addl $4, %esp
    leave 
    ret

#
# Memory utilities functions
#

/*
 *  _sig_:int s_memset(void *s, int c, size_t n);
 *  @in 8(%esp) [s]
 *  @in 12(%esp) [c]
 *  @in 16(%esp) [n]
 *  @out %eax [void *]
 */
ENTRY s_memset
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %edi
    movb 12(%esp), %al
    movl 16(%esp), %ecx

    cld
    rep stosb

    movl %edi, %eax

    leave 
    ret





