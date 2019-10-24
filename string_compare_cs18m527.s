/******************************************************************************
* file: string_compare_CS18M527.s
* author: Badrinath
* Guide: Prof. Madhumutyam IITM, PACE
* this file contains implementation for find if the given string is
*  greater than the first string.
* "start1" contains the first string and "start2" contains strings 
* that needs to be compared
* Results are stored in the words GREATER.
* STRING1 >= STRING2 then GREATER = 0x00000000
* STRING2 > STRING2 then GREATER = 0xFFFFFFFF
***********************************************************************/

@ BSS section
      .bss

@ DATA SECTION
	.data
length1:	.word   3
start1:		.ascii "CAT"
start2:		.ascii "BAT", "CAT", "CUT"

.align 4
GREATER:	.word  0x00000000, 0x00000000, 0x00000000

@ TEXT section
		.text
.globl _main

_main:

	/*
         * Register usage
	 * r0 -> address of the length variable and later as cntr, value of the length
	 * r1 -> base address of the string 1
	 * r2 -> base address of the string 2
	 * r3 -> ASCII value of the string1's character
	 * r4 -> ASCII value of the string2's character
	 * r5 -> base address of the result (GREATER) value
	 * r9 -> flag to indicate greater or lesster
	 */

	// Loop for the length, note it is already given that the 
	mov r0, #0x0
	mov r1, #0x0
	mov r2, #0x0
	mov r3, #0x0
	mov r4, #0x0
	mov r5, #0x0
	mov r6, #0x0 
	mov r7, #0x0 
        mov r8, #0x0
        mov r9, #0x0


	// Load the start addresses for the strings
	// and the length of the strings.
	// Note that strings are of same length
	ldr r5, = GREATER
	ldr r2, =start2
	// there are three combinations of the comparision
	mov r7, #3

words_loop:

	// load the register for base string 
	// Note the first string is common for all 
	// comparisons

	ldr r1, =start1
	ldr r0, =length1



	#mov r2, r6
	#mov r5, r7

	cmp r7, #0 
	beq words_loop_done

	// Load the length to the register r0,
        // which becomes the loop counter
	// this has to be done everytime for words loop, since we 
  	// are decrementing the counter 
	ldr r8, [r0]


cmp_loop_1:

	// if we are done, exit
	// Note, length is given as equal and hence length
	// of the strings need not be compared.
	cmp r8, #0
	beq words_loop_done 

	// Load a byte from the location of the strings
	// Compare the byte (ASCII) values of the 
	// characters and then auto increment the base address
	ldrb r3, [r1], #1 
	ldrb r4, [r2], #1 

	cmp   r3,  r4
	movlt r9,  #0xFFFFFFFF
	bne  cmp_loop_1_done

	sub r8, #1
	b cmp_loop_1


cmp_loop_1_done:

	// Result in location r5. Autoincremented
	// post load after store, so that it can be 
	// store the result of the next iteration of 
	// the words	
	str r9, [r5], #4 

	// Branch to self for insepction
	sub r7, #1
	b words_loop	

words_loop_done:
	b .  
.end
