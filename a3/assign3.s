// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #3

	// setting register values for FP and LR
	fp		.req	x29
	lr		.req	x30	

	// defining macros
		
		 
	
	
	
	
	// defining the size of the variables
	
	
	
	
	
	

	// assembler equates for allocating memory from the stack
	
	
	

	// setting the 100 relative to frame record
	
	
	
	
	

unsorted:	.string "Unsorted array:\n"			// the string format to show the following values are unsorted
sorted:		.string "\nSorted array:\n"			// the string format to show the following values are sorted
output:		.string "v[%d]: %d\n"			 	// the string format used for printing out the values of the array
	
		.balign		4				// makes all the addresses divisible by 4 so they are aligned with the word length
		.global		main				// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
	stp		fp, lr, [sp, -(16+100*4+4+4+4+4)&-16]!			// stores the FP and LP in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP
	add 		x19, fp, 100*4+4+4+4+4		// adding FP and 100*4+4+4+4+4 and storing it in x19 (total array capacity)
	mov		w20, 0				// setting the index value to 0
	str		w20, [fp, 16]			// store w20 in address FP
	b		test1 					// check loop test for this first loop in the program 
	
initialize: 
	bl 		rand					// call the function rand to generate pseudorandom numbers
	ldr		w20, [fp, 16]			// load w20 from FP
	and		w22, w0, 0x1FF				// AND w0 with 0x1FF and store the result in w22
	str		w22, [x19, w20, SXTW 2]	// store w22 in address x19
	add		w20, w20, 1 			// increment array_index_r by 1 each iteration of the loop
	str		w20, [fp, 16]			// store w20 in address FP
	
test1:	
	cmp		w20, 100 				// check loop condition to see if array_index_r is less than 100
	b.lt		initialize				// if array_index_r is less than 100, execute the loop body again
	adrp		x0, unsorted				// first step in printing the unsorted prompt
	add		x0, x0, :lo12:unsorted			// second step in printing the unsorted prompt
	ldr		w1, [fp, 16]				// loading register w1 with the address of FP
	ldr		w2, [x19, w20, SXTW 2]	// loading register w2 with with the address of x19
	bl		printf					// calling the function printf to display output to screen
	mov		w20, 0				// reset the index value to 0
	str		w20, [fp, 16]			// store w20 in address FP
	b		test2					// jump to label "test2"



	
	
loopunsorted:
	adrp		x0, output				// first step in printing the unsorted array values
	add		x0, x0, :lo12:output			// second step in printing the unsorted array values
	ldr		w1, [fp, 16]				// loading register w1 with the address of FP
	ldr		w2, [x19, w20, SXTW 2]	// loading register w2 with the address of x19
	bl		printf					// calling the function printf to display output to the screen 

	add 		w20, w20, 1			// incrementing the index by 1
	str		w20, [fp, 16]			// store w20 in address FP
	
test2:
	cmp		w20, 100				// loop test to see if index has reaching 100
	b.lt		loopunsorted				// if it is less than 100 iterate through "loopunsorted" again

reset1:	
	mov		w23, 100				// setting w23 equal to 100
	lsr		w23, w23, 1				// dividing the value of w23 by 2
	str		w23, [fp, 24]			// store w23 in FP
	b		test3					// jump to label "test3"


	

	
shellsort1:
	ldr		w23, [fp, 24]			// load w23 from FP
	str		w23, [fp, 16]				// store w23 in the address of 16
	b		test4					// jump to label "test4"
	
shellsort2:
	ldr		w20, [fp, 16]			// load w20 from FP
	ldr		w21, [fp, 20]			// load w21 from FP
	ldr		w23, [fp, 24]			// load w23 from FP
	sub		w21, w20, w23			// subtracting w23 from w20 and storing the result in w20
	str		w21, [fp, 20]			// store w21 in FP
	b		test5					// jump to label "test5"
	
shellsort3:
	ldr 		w24, [fp, 28]			// loading w24 from FP
	ldr		w21, [fp, 20]			// loading w21 from FP
	ldr		w27, [x19, w21, SXTW 2]	// loading w27 into x19, w21
	str		w27, [fp, 28]			// storing w27 in 28
	ldr		w23, [fp, 24]			// loading w23 from FP
	add		w25, w21, w23			// adding w23 and j and storing the result i w25
	ldr		w26, [x19, w25, SXTW 2]		// loading w26 with x19, w25 (w23 + j)
	str		w26, [x19, w21, SXTW 2]	// storing w26 with x19, w21
	ldr 		w24, [fp, 28]			// loading w24 from FP
	str		w24, [x19, w25, SXTW 2]		// storing w24 with x19, w25
	sub		w21, w21, w23			// subtracting w23 from w21 and storing the result in w21
	str		w21, [fp, 20]			// storing w21 into FP

test5:
	ldr		w21, [fp, 20]			// loading w21 from FP
	cmp		w21, 0				// comparing w21 with 0
	b.lt		incrementing				// if w21 is less than 0 jump to shellsort2
	ldr		w21, [fp, 20]			// loading w21 from FP
	ldr		w23, [fp, 24]			// loading w23 from FP
	add		w26, w21, w23			// adding w21 with w23 and storing it in w26
	ldr		w28, [x19, w26, SXTW 2]		// load register w28 with x19, w26 (j + w23)
	ldr		w22, [x19, w21, SXTW 2]	// load register w22 with x19, w21
	cmp		w22, w28				// compare registers w26 and w27
	b.lt		shellsort3				// jump to label "shellsort3" if w22 is less than w23

incrementing:
	ldr		w20, [fp, 16]			// loading w20 from FP
	add		w20, w20, 1			// incrementing w20 by 1
	str		w20, [fp, 16]			// storing w20 in FP
	
test4:
	ldr		w20, [fp, 16]			// loading w20 in FP
	cmp		w20, 100				// comparing w20 with 100
	b.lt		shellsort2				// if index w20 is less than 100 jump to shellsort2
	ldr		w23, [fp, 24]			// loading w23 from FP
	lsr		w23, w23, 1				// dividing w23 by 2 and storing the result in w23
	str		w23, [fp, 24]			// storing w23 in FP
	
test3:
	ldr		w23, [fp, 24]			// loading w23 from FP
	cmp		w23, 0					// comparing w23 with 0	
	b.gt		shellsort1				// if w23 is greater than 0 jump to shellsort1

reset2:	
	adrp		x0, sorted				// first step in printing the unsorted prompt	
	add		x0, x0, :lo12:sorted			// second step in printing the unsorted prompt
	ldr		w1, [fp, 16]				// loading register w1 with the address of FP
	ldr		w2, [x19, w20, SXTW 2]	// loading register w2 with with the address of x19
	bl		printf					// calling the function printf to display output to screen

	ldr		w20, [fp, 16]			// loading w20 from FP
	mov		w20, 0				// reset the index value to 0
	str		w20, [fp, 16]			// store w20 in address FP
	b		test6					// jump to label "test6"
	

	


loopsorted:
	ldr		w20, [fp, 16]			// loading w20 from FP
	
	adrp		x0, output				// first step in printing the unsorted array values
	add		x0, x0, :lo12:output			// second step in printing the unsorted array values
	ldr		w1, [fp, 16]				// loading register w1 with the address of FP
	ldr		w2, [x19, w20, SXTW 2]	// loading register w2 with the address of x19
	bl		printf					// calling the function printf to display output to the screen 

	add 		w20, w20, 1			// incrementing the index by 1
	str		w20, [fp, 16]			// store w20 in address FP
	
test6:
	ldr		w20, [fp, 16]			// loading w20 from FP
	cmp		w20, 100				// loop test to see if index has reaching 100
	b.lt		loopsorted				// if it is less than 100 iterate through "loopunsorted" again
	
done:	ldp		x29, x30, [sp], --(16+100*4+4+4+4+4)&-16			// restore sp to x29 and x30 then do sp +--(16+100*4+4+4+4+4)&-16 and set to sp
	ret							// return to the OS
