
.include "libS.inc"

.data

.text

shellcode_init:
    pushl $rk_intercept
    ret


ENTRY kernel_func
    pushl %ebp
    movl %esp, %ebp

    movl $2, %eax

    movl %ebp, %esp
    popl %ebp
    ret

ENTRY rk_intercept
    pushl %ebp
    movl %esp, %ebp

    # do something...
    movl $1, %eax

    leave 
    ret

/**
 *  \fn void test_setup(void);
 */
ENTRY test_setup
    pushl %ebp
    movl %esp, %ebp

    pushl $done
    jmp shellcode_init

done:
    leave
    ret

