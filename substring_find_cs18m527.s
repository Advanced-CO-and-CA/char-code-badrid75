/******************************************************************************
* file: substring_find_cs18m527
* author: Badrinath
* Guide: Prof. Madhumutyam IITM, PACE
* This file implements code to find if a given STRING is substring of the 
* first given string
* Window based search is implemented, ie, 
* The master string (first string) is searched for substring (STRING2), 
* starting from index 0
*    _ _ _ _ _ _ _ _ _
*  
*   ^(start search from here)
* if not found, increment the index from where to search in string 1
* ie, 
*
*     - - - - - - - - 
* In this implementation above, string1 (MASTER) is assumed to by > than substring
* candidate (string2)
* The index of Master string (string1) from where the substring is found (if found)
* is stored in the PRESENT location, 1 word for each substring
******************************************************************************/



@ BSS section
      .bss

@ DATA SECTION
	.data
length1:	.word   3
STRING:		.asciz "CS6620"
SUBSTR:		.asciz "S5", "620", "6"

.align 4
PRESENT:	.word  0x00000000, 0x00000000, 0x00000000

// These are for stroring some intermediate results
.align 4
length_str:	.word 0x0
length_substr:  .word 0x0
scatch_index:	.word 0x0

.align 4
	scratch1:  .word 0x0

@ TEXT section
		.text
.globl _main

_main:

	// Clear the regs for use.

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
        mov r10, #0x0
        mov r11, #0x0
        mov r12, #0x0
        mov r13, #0x0


	// Calculate and store the length of the 
	// STRING (base string) once and store
	// check each value if it is NULL, while 
	// incrementing the counter to track 
	// the length
	ldr r0, =STRING
	mov r6, r0  // r6 is scratch

strnlen_loop_1:
	ldrb r7, [r6], #1
	cmp  r7, #0
	addne r1, #1
	bne strnlen_loop_1

	// r0 -> base address for STRING
	// r1 -> Length of STRING

	// This is counter for number of substring candidates
	mov r7, #3

	// this is the location for result "PRESENT"
	// this gets incremented by 4 bytes per string

	ldr r13, =PRESENT

       // First time initialize here, for the next iterations, happens in the 
       // loop prep_next_string
	ldr r2, =SUBSTR  // this is going to be the base address of the SUBSTR
	mov r6, r2       // r6 is scratch to operate

top_loop:


        cmp  r7, #0
	beq top_done

	ldr r0, = STRING
	// Compare for each string


	// Find the length of the "second" string
	// iteration has to happen "n" times

	// Find the length of the substring for each substring

	mov r3,#0
strnlen_loop_2:

	ldrb r5, [r6], #1
	cmp  r5, #0
	addne r3, #1
	bne strnlen_loop_2

	// At the end of this loop
	// r2 -> base address of first substr
	// r3 -> length of the first substr



	// r0 -> base address of Master
	// r1 -> length of Master
	// r2 -> base address of SUBSTR
	// r3 -> length of substring

	// Implement a window on master string, Keep incrementing the index of master string
	// Match the substring for that many bytes of substring to be found. If found, 
	// the starting index of the Master string is the result. 
	// If we exhaust the master string, substring not found.
	// At start of every match search, make sure to compare the length of Master string 
	// available. If the remaining length of master string < substring length, breakout,
	// We cannot go past the master string and also means substring wasnt found

	mov r8, #0x0  // Going to be our index of the match at the start
	mov r5, #0x0 // offset into the Master string.
	mov r6, #0


	// r8 -> flag
	// r10-> remaining length of master string
	// r9->  shadow of master base + offset

       // Overall length available for comparing in Master in len(Master) at start
	mov r10, r1
	mov r9, r0

	mov r4, r3

	mov r11, #0
	mov r12, #0


window_search:

	cmp  r4, #0
	beq  sub_string_done

	ldrb r11, [r9,r5]
	ldrb r12, [r2,r6]

        // this is mismatch and go to the same place
	cmp r11, r12  
	bne sub_mismatch


	add r5, r5, #1
	add r6, r6, #1

	sub r4, r4, #1
		
	b window_search
sub_mismatch:

	// Check the remaining Master length
	sub r10, r10, #1
	cmp r10, r3
	blt master_string_done

	//increment the index for the master
	// for next window
	add r9, r9, #1 
	mov r5, #0
	mov r6, #0

	b window_search

master_string_done:
	mov r8, #0x0
	b prep_next_string
	

sub_string_done:

	sub r8, r9, r0
	add r8, #1 // index starts from 0
prep_next_string:
	str r8, [r13], #4

	// Goto the next substring
	// Increment the string to point to the next by adding length of current string compared
	add r2, r2, r3

	// add "1" for the null termination
	add r2, r2, #1
	mov r6, r2

	// decrement the count for total compares
	sub r7, #1 
	b top_loop

top_done:
	b .


