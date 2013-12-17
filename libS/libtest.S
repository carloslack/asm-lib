
.include "libS.inc"

.data
.text

/**
 * \fn int c_rk(int x, int y);
 */
ENTRY c_rk
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %ebx
    movl 12(%esp), %ecx

    addl %ebx, %ecx
    movl %ecx, %eax

    leave
    ret

/**
 * \fn int c_orig(int x, int y);
 */
ENTRY c_orig
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %ebx
    movl 12(%esp), %ecx

    addl %ebx, %ecx
    movl %ecx, %eax

    leave 
    ret

/**
 *  \fn int rk_intercept(void *c_orig, void *c_rk, int x, int y);
 */
ENTRY rk_intercept
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %esi #c_orig
    movl 12(%esp), %edi #c_rk

    movl 16(%esp), %ebx #first arg
    movl 20(%esp), %ecx #second arg

    subl $8, %esp
    movl %ebx, -4(%ebp) #saved first
    movl %ecx, -8(%ebp) #saved second

    pushl -8(%ebp)
    pushl -4(%ebp)
    call *%edi #c_rk
    addl $8, %esp

    pushl -8(%ebp)
    pushl -4(%ebp)
    call *%esi #c_orig
    addl $8, %esp


    addl $8, %esp


   leave 
   ret




    
    

    leave
    ret
