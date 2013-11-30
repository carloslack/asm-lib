#
# libS.inc
#
# Include from libS.S
#

# ENTRY is libS local
.macro ENTRY fn
    .globl \fn   
    .type \fn, @function;\fn:
.endm

/*
 * bforward: starts at bit 0 
 * breverse: starts at most significant bit 
 * 
 *  @see s_bitscan
 */
.equ bforward, 0
.equ breverse, 1
