
.include "libS.inc"

.data
.text
.extern s_log

/**
 * \fn int c_rk(char *x, char *y);
 */
ENTRY c_rk
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %ebx # first arg
    movl 12(%esp), %ecx # second arg

    subl $4, %esp
    movl %ecx, -4(%ebp)

    pushl %ebx
    call s_log
    addl $4, %esp

    movl -4(%ebp), %ecx
    pushl %ecx
    call s_log
    addl $4, %esp

    movl $0, %eax

    leave
    ret

/**
 * \fn int c_orig(char *x, char *y);
 */
ENTRY c_orig
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %ebx
    movl 12(%esp), %ecx

    subl $4, %esp
    movl %ecx, -4(%ebp)

    pushl %ebx
    call s_log
    addl $4, %esp

    movl -4(%ebp), %ecx
    pushl %ecx
    call s_log
    addl $4, %esp

    movl $0, %eax

    leave
    ret

/* 
 * push $c_rk
 * push $c_orig
 * push $rk_intercept
 * ret
 */
/**
 *  \fn int rk_intercept(void *c_orig, void *c_rk, char *x, char *y);
 */
ENTRY rk_intercept
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %esi #c_orig
    movl 12(%esp), %edi #c_rk

    movl 16(%esp), %ecx #first arg
    movl 20(%esp), %edx #second arg


    subl $12, %esp
    movl %ecx, -4(%ebp) #saved first
    movl %edx, -8(%ebp) #saved second
    movl %esi, -12(%ebp) #save original function call
    
    pushl %edx
    pushl %ecx
    call *%edi #c_rk
    addl $8, %esp

    # restore previously saved registers 
    # for use
    movl -4(%ebp), %ecx
    movl -8(%ebp), %edx
    movl -12(%ebp), %esi

    pushl %edx
    pushl %ecx
    call *%esi #c_orig
    addl $8, %esp

    # restore saved space
    addl $12, %esp

bye:
   leave 
   ret

