#
# main.inc
#
# Include from main.S
#

.macro NARG reg
    popl %eax
    movl %eax, \reg
    decl \reg
    pushl \reg; .endm

#   Gets current argument, argv[x]
.macro GETARG reg; movl 8(%esp), \reg; .endm

#   Overwrites current argument by the
#   next one. (shift)
.macro SETARG reg
    popl \reg
    addl $4, %esp
    pushl \reg; .endm

