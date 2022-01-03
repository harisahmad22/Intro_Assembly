// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #4

// setting register values for FP and LR
	fp		.req	x29
	lr		.req	x30	

// equal size
	
	
	 
		
// struct coord
	coord_x = 0
	coord_y = 4

// struct size
	size_width = 0
	size_length = 4

// struct pyramid
	size_base = 0
	coord_centre = 8
	pyr_height = 16
	pyr_volume = 20
	pyramid_size = 24
	khafre_s = 16
	cheops_s = pyramid_size+khafre_s
	
// assembler equates for allocating memory from the stack
	
	
	

// the multiple strings used as output
fmt1:	.string "Pyramid %s\n"
fmt2:	.string "\tCenter = (%d, %d)\n"
fmt3:	.string "\tBase width = %d, Base length = %d\n"
fmt4:	.string "\tHeight = %d\n"
fmt5:	.string "\tVolume = %d\n\n"
fmt6:	.string "Initial pyramid values:\n"
fmt7:	.string "\nNew pyramid values:\n"
fmt8:	.string "khafre\n"
fmt9:	.string "cheops\n"
	
	.balign		4						// makes all the addresses divisible by 4 so they are aligned with the word length
	.global		main						// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
	stp		fp, lr, [sp, -(16+pyramid_size+pyramid_size)&-16]!				// stores the FP and LP in the stack with two double spaces
	mov		fp, sp						// moves the SP to the LP

	add		x8, fp, khafre_s				// add khafre_s with fp and store in x8
	mov 		w0, 10						// set w0 = 10
	mov		w1, 10						// set w1 = 10
	mov		w2, 9						// set w2 = 9
	bl 		newPyramid					// go to the subroutine newPyramid
	
	add		x8, fp, cheops_s				// add cheops_s with fp and store in x8
	mov		w0, 15						// set w0 = 15
	mov		w1, 15						// set w1 = 15
	mov		w2, 18						// set w2 = 18
	bl		newPyramid					// go to the subroutine newPyramid

	adrp		x0, fmt6					// step 1 in printing out string fmt6
	add		x0, x0, :lo12:fmt6				// step 2 in printing out string fmt6
	bl 		printf						// calling the print function

	adrp		x0, fmt8					// step 1 in printing out string fmt8
	add		x0, x0, :lo12:fmt8				// step 2 in printing out string fmt8
	add		x1, fp, khafre_s				// add khafre_s with fp and store in x1
	bl 		printPyramid					// calling the print function
						
	adrp		x0, fmt9					// step 1 in printing out the string fmt9
	add		x0, x0, :lo12:fmt9				// step 2 in printing out the string fmt9
	add		x1, fp, cheops_s				// add cheops_s with fp and store in x1
	bl 		printPyramid					// calling the print function

	//comparison calculations.

	add		x0, fp, khafre_s				// add khafre_s with fp and store in x0
	add		x1, fp, cheops_s				// add cheops_s with fp and store in x1
	bl		equalSize					// go to subroutine "equalSize"

	cmp		w0, 0					// compare w0 with 0 (0)
	b.ne		skip						// if not equal to 0 go to label "skip"

	add		x0, fp, cheops_s				// add fp with cheops_s and store in x0
	mov		w1, 9						// set w1 equal to 9
	bl		expand						// go to subroutine "expand"

	add		x0, fp, cheops_s				// add cheops_s with fp and store in x0
	mov		w1, 27						// set w1 equal to 27
	mov		w2, -10						// set w2 equal to -10
	bl 		relocate					// go to subroutine "relocate"

	add		x0, fp, khafre_s				// add khafre_s with fp and store in x0
	mov		w1, -23						// set w1 equal to -23
	mov		w2, 17						// set w2 equal to 17
	bl 		relocate					// go to subroutine "relocate
	
skip:	
	adrp		x0, fmt7					// step 1 in printing out string fmt6
	add		x0, x0, :lo12:fmt7				// step 2 in printing out string fmt6
	bl 		printf						// calling the print function

	adrp		x0, fmt8					// step 1 in printing out string fmt8
	add		x0, x0, :lo12:fmt8				// step 2 in printing out string fmt8
	add		x1, fp, khafre_s				// add khafre_s with fp and store in x1
	bl 		printPyramid					// calling the print function
						
	adrp		x0, fmt9					// step 1 in printing out the string fmt9
	add		x0, x0, :lo12:fmt9				// step 2 in printing out the string fmt9
	add		x1, fp, cheops_s				// add cheops_s with fp and store in x1
	bl 		printPyramid					// calling the print function
done:
	ldp		fp, lr, [sp], --(16+pyramid_size+pyramid_size)&-16				// restore sp to x29 and x30 then do sp +--(16+pyramid_size+pyramid_size)&-16 and set to sp
	ret								// return to the OS



				// the amount of memory to allocate for this subroutine
				// the amount of memory to deallocate for this subroutine
newPyramid:	
	stp		fp, lr, [sp, -(16+pyramid_size)&-16]!			// allocate memory in stack
	mov		fp, sp						// set fp to sp
	
	str		wzr, [fp, 16 + coord_centre + coord_x] 		// p.x = 0	
	str		wzr, [fp, 16 + coord_centre + coord_y] 		// p.y = 0

	mov		w26, w0						// set w26 to value of w0
	str		w0, [fp, 16 + size_base + size_width]		// store contents of w0 as the width in stack

	mul		w26, w26, w1					// multiply w26 with w1 and store in w26
	str		w1, [fp, 16 + size_base + size_length]		// store contents of w1 as the length in stack

	mul 		w26, w26, w2					// multiply w26 with w2 and store in w26
	str		w2, [fp, 16 + pyr_height]			// store contents of w2 as height in the stack

	mov		w27, 3						// set w27 to 3
	udiv		w26, w26, w27					// divid w26 by 3 and store in w26
	str		w26, [fp, 16 + pyr_volume]			// store w26 value in the stack

	
	ldr		w10, [fp, 16 + coord_centre + coord_x]		// set in main
	str		w10, [x8, coord_centre + coord_x]		// x8 = p.c.x

	ldr		w10, [fp, 16 + coord_centre + coord_y]		// set in main
	str		w10, [x8, coord_centre + coord_y]		// x8 = p.c.y

	ldr		w10, [fp, 16 + size_base + size_width]		// set in main
	str		w10, [x8, size_base + size_width]		// x8 = p.b.w

	ldr		w10, [fp, 16 + size_base + size_length]		// set in main
	str		w10, [x8, size_base + size_length]		// x8 = p.b.l

	ldr		w10, [fp, 16 + pyr_height]			// set in main
	str		w10, [x8, pyr_height]				// x8 = height

	ldr		w10, [fp, 16 + pyr_volume]			// set in main
	str		w10, [x8, pyr_volume]				// x8 = volume
endNewPyramid:	
	ldp		fp, lr, [sp], --(16+pyramid_size)&-16		// restore fp and lr
	ret								// return subroutine



							// size of x23
				// amount of memory to allocate
			// amount of memory to deallocate
							// offset for x23
printPyramid:
	stp		fp, lr, [sp, -(16+8)&-16]!		// allocate memory in stack
	mov		fp, sp						// set fp to sp				

	// storing value of x23 in the stack memory
	str		x23, [fp, 16]				// store the value of x23 in stack memory
	mov		x23, x1						// set x23 = x1 (pyramid pointer)

	// first print statement
	mov		x1, x0						// store contents of x0 in x1
	adrp		x0, fmt1					// step 1 in printing out the fmt1 string
	add		x0, x0, :lo12:fmt1				// step 2 in printing out the fmt1 string
	bl		printf						// calling print function

	// second print statement
	adrp		x0, fmt2					// step 1 in printing out the fmt2 string
	add		x0, x0, :lo12:fmt2				// step 2 in printing out the fmt2 string
	ldr		w1, [x23, coord_centre + coord_x]		// value to go in placeholder 1
	ldr		w2, [x23, coord_centre + coord_y]		// value to go in placeholder 2
	bl		printf						// calling print function

	// third print statement
	adrp		x0, fmt3					// step 1 in printing out the fmt3 string
	add		x0, x0, :lo12:fmt3				// step 2 in printing out the fmt3 string
	ldr		w1, [x23, size_base + size_width]		// value to go in placeholder 1
	ldr		w2, [x23, size_base + size_length]		// value to go in placeholder 2
	bl		printf						// calling print function
	
	// fourth print statement
	adrp		x0, fmt4					// step 1 in printing out the fmt4 string
	add		x0, x0, :lo12:fmt4				// step 2 in printing out the fmt4 string
	ldr		w1, [x23, pyr_height]				// value to go in the placeholder
	bl		printf						// calling the print function

	// fifth print statement
	adrp		x0, fmt5					// step 1 in printing out the fmt 5 string
	add		x0, x0, :lo12:fmt5				// step 2 in printing out the fmt 5 string
	ldr		w1, [x23, pyr_volume]				// value to go in placeholder
	bl		printf						// calling the print function 
endPrintPyramid:
	ldr		x23, [fp, 16]				// load back x23
	
	ldp		fp, lr, [sp], --(16+8)&-16		// deallocate memory from stack for this subroutine
	ret								// return subroutine


	
								// allocate 8 bytes
								// allocate another 8 bytes
								// allocate 4 bytes
			// total space to be allocated
					// total space to be deallocated
								// offset of 16
								// offset of 24
equalSize:
	stp		fp, lr, [sp, -(16+8+8+4)&-16]!				// store the fp and lr in the stack
	mov		fp, sp							// set fp to sp

	str		x23, [fp, 16]					// store x23 in the stack with 16 offset
	str		x24, [fp, 24]					// store x24 in the stack with 24 offset
	mov		w22, 0						// set w22 equal to 0 (0)

	ldr		w23, [x0, size_base + size_width]			// load contents of w23 into x0 + width offset
	ldr		w24, [x1, size_base + size_width]			// load contents of w24 into x1 + width offset
	
	cmp		w23, w24						// compare the values of w23 and w24
	b.ne		endEqualSize						// if w23 is equal to w24, continue

	ldr		w23, [x0, size_base + size_length]			// load contents of w23 into x0 + length offset
	ldr		w24, [x1, size_base + size_length]			// load contents of w24 into x1 + length offset
	
	cmp		w23, w24						// compare the values of x23 and x24
	b.ne		endEqualSize						// if w23 is equal to w24, continue

	ldr		w23, [x0, pyr_height]					// load contents of w23 into x0 + height offset
	ldr		w24, [x1, pyr_height]					// load contents of w24 into x1 + height offset
	
	cmp		w23, w24						// compare the values of x23 and x24
	b.ne		endEqualSize						// if w23 is equal to 24, continue

	mov		w22, 1						// set the value of w22 equal to 1 (1)
endEqualSize:
	ldr		x23, [fp, 16]					// restore the register w23
	ldr		x24, [fp, 24]					// restore the register w24
	mov		w0, w22						// set w0 equal to the w22 (return value)
	
	ldp		fp, lr, [sp], --(16+8+8+4)&-16				// deallocate memory from stack for this subroutine
	ret									// return subroutine



							// define value of 8
					// amount of memory to allocate in stack
					// amount of memory to deallocate in stack
							// define value of 16 to 16
expand:
	stp		fp, lr, [sp, -(16+8)&-16]!			// allocate memory of subroutine
	mov		fp, sp						// set fp to sp

	str		x21, [fp, 16]				// store x21 original value in stack
	
	ldr		w11, [x0, size_base + size_width]		// load the width in stack
	mul		w11, w11, w1					// set w11 equal to w11 multiplied by w11
	mov		w20, w11					// set w20 to w11
	str		w11, [x0, size_base + size_width]		// store the width in stack

	ldr		w11, [x0, size_base + size_length]		// load the length in stack
	mul		w11, w11, w1					// multiply w11 by w1 and store in w11
	mul		w20, w20, w11					// multiple w20 by w11 and store in w20
	str		w11, [x0, size_base + size_length]		// store the length in stack

	ldr		w11, [x0, pyr_height]				// load the height in stack
	mul		w11, w11, w1					// multiply w11 by w1 and store in w11
	mul		w20, w20, w11					// multiply w20 by w20 and store in w20
	str		w11, [x0, pyr_height]				// store the height in stack

	mov		w24, 3						// set w24 equal to 3
	sdiv		w20, w20, w24					// divide w20 by w24 and store in w20

	ldr		w11, [x0, pyr_volume]				// load contents of w11 in the space for volume
	mov		w11, w20					// set w11 to w20
	str		w11, [x0, pyr_volume]				// store contents of w11 in the space for volume
endExpand:		
	ldr		x21, [fp, 16]				// restore the initial value of x21 register
	
	ldp		fp, lr, [sp], --(16+8)&-16			// deallocate memory from the stack
	ret								// return subroutine



relocate:
	stp		fp, lr, [sp, -16]!				// allocate memory in stack
	mov		fp, sp						// set fp to sp

	ldr		w12, [x0, coord_centre + coord_x]		// load in the coordx
	add		w12, w12, w1					// add w12 and w1 and store in w12
	str		w12, [x0, coord_centre + coord_x]		// store the new coordx in offset for coordx
	
	ldr		w12, [x0, coord_centre + coord_y]		// load in the coordy
	add		w12, w12, w2					// add w12 and w2 and store in w12
	str		w12, [x0, coord_centre + coord_y]		// store the new coordy in offset for coordy
endRelocate:
	ldp		fp, lr, [sp], 16				// deallocate memory from stack
	ret								// return subroutine
