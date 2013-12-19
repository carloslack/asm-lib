/**
 *
 *  hash  <carloslack@gmail.com>
 *
 *  ASM helper library (under construction)
 *
 */

/**
 *  Header file for ENTRY macro
 */
.include "libS.inc"

.section .rodata
endfuncstrstr: .ascii "endfunc\0xa"
entryfuncstr: .ascii "entryfunc\0xa"
nl: .byte 0xa /**< new line */

/**
 * Syscall numbers
 */
.equ SYS_exit, 1
.equ SYS_read,  3
.equ SYS_write, 4

.text

#
# Debug functions
#

/**  
 *  \fn size_t s_log(const char *str);
 *  @param str
 *  @return %eax [number of characters processed]
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

end_s_log:
    addl $4, %esp 
    movl -4(%ebp), %eax  
    leave
    ret

#
# String functions
#

/**
 *  \fn size_t s_strlen(const char *str);
 *  @param str
 *  @return %eax [length of given string]
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

/**
 *  \fn size_t s_strncmp(const char *s1, const char *s2, size_t n);
 *  @param 8(%esp) [s1]
 *  @param 12(%esp) [s2]
 *  @param 16(%esp) [n]
 *  @return %eax [result]
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

/**
 *  \fn int s_mod(unsigned int x, unsigned int y);
 *  @param 8(%esp) [x]
 *  @param 12(%esp) [y]
 *  @return %ax [remainder]
 */
ENTRY s_mod
    pushl %ebp
    movl %esp, %ebp

    xor %dx, %dx
    xorl %eax, %eax
    
    mov 8(%ebp), %ax   
    mov 12(%ebp), %bx   
    div %bx             
    movzwl %dx, %eax /**< save return, 0 padding */      

    leave
    ret

/**
 * 
 * \fn int s_bitscandw(int direction, int dword);
 *  @param 8(%esp) [direction]
 *  @param 12(%esp) [dword]
 *  @return %eax [offset]   
 */
ENTRY s_bitscandw
    pushl %ebp
    movl %esp, %ebp
    xorl %edi, %edi

    movl 8(%esp), %edi
    movl 12(%esp), %esi
    subl $4, %esp /**< save space */

    movl %esi, -4(%ebp) /**< save dword in local var */

    /**
     * will reuse %esi ahead
     */
    xorl %esi, %esi 

    cmpl $bforward, %edi
    je .bsfl
    cmpl $breverse, %edi
    je .bsrl

    /**
     * Invalid argument
     */
    jmp .unset

.bsfl: /**< forward */
    bsfl -4(%ebp), %esi
    jz .unset
    movl %esi, %eax
    jmp .end

.bsrl: /**< reverse */
    bsrl -4(%ebp), %esi
    jz .unset
    movl %esi, %eax
    jmp .end

/**
 * Argument is zero or invalid
 */
.unset:
    movl $-1, %eax
.end:
    addl $4, %esp
.teste:
    leave 
    ret

/**
 * 
 * \fn int s_bitscanw(int direction, unsigned short word);
 *  @param 8(%esp) [direction]
 *  @param 12(%esp) [word]
 *  @return %eax [offset]   
 */
ENTRY s_bitscanw
    pushl %ebp
    movl %esp, %ebp
    xorl %ecx, %ecx

    movl 8(%esp), %esi 
    movw 12(%esp), %cx

    movzwl %cx, %edi 
    pushl %edi
    pushl %esi
    
    call s_bitscandw
    addl $8, %esp

    leave 
    ret

/**
 * 
 * \fn int s_bitscanb(int direction, unsigned char byte);
 *  @param 8(%esp) [direction]
 *  @param 12(%esp) [bye]
 *  @return %eax [offset]   
 */
ENTRY s_bitscanb
    pushl %ebp
    movl %esp, %ebp
    xorl %ecx, %ecx

    movl 8(%esp), %esi
    movb 12(%esp), %cl

    movzbl %cl, %edi 

    pushl %edi
    pushl %esi
    call s_bitscandw
    addl $8, %esp
.bye:
    leave
    ret

/**
 * Shift right
 * 
 * \fn int s_shrl(unsigned short shift, int *val);
 *  @param 8(%esp) [shift]
 *  @param 12(%esp) [*val]
 *  @return %eax [shift positions]   
 */
ENTRY s_shrl
    pushl %ebp
    movl %esp, %ebp

    xorl %ecx, %ecx
    movb 8(%esp), %cl
    movl 12(%esp), %edi
    shrl %cl, (%edi)
    
    movl %ecx, %eax /**< number of shift positions */

    leave
    ret

/**
 * Shift left
 * 
 * \fn int s_shll(unsigned short shift, int *val);
 *  @param 8(%esp) [shift]
 *  @param 12(%esp) [*val]
 *  @return %eax [shift positions]   
 */
ENTRY s_shll
    pushl %ebp
    movl %esp, %ebp

    xorl %ecx, %ecx
    movb 8(%esp), %cl
    movl 12(%esp), %edi
    shll %cl, (%edi)
    
    movl %ecx, %eax /**< number of shift positions */

    leave
    ret

#
# Memory utilities functions
#

/**
 *  \fn int s_memset(void *s, int c, size_t n);
 *  @param 8(%esp) [s]
 *  @param 12(%esp) [c]
 *  @param 16(%esp) [n]
 *  @return %eax [void *]
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

