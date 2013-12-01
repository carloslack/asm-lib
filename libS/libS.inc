/**
 *  libS.inc
 *
 * Header file of libS.S
 */

/**
 * ENTRY function prototype macro
 *
 *
 */
.macro ENTRY fn
    .globl \fn   
    .type \fn, @function;\fn:
.endm

/**
 * bforward: starts at bit 0 
 * breverse: starts at most significant bit 
 * 
 *  @see s_bitscandw
 */
.equ bforward, 0
.equ breverse, 1
