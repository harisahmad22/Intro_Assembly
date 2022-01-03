// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #3

	// setting register values for FP and LR
	fp		.req	x29
	lr		.req	x30	

	// defining macros
	define(array_base,x19)	
	define(index_i,w20)	 
	define(index_j,w21)
	define(gap,w23)
	define(temp,w24)
	
	// defining the size of the variables
	define(size,100)
	define(array_size,size*4)
	define(gap_size,4)
	define(temp_size,4)
	define(i_size,4)
	define(j_size,4)

	// assembler equates for allocating memory from the stack
	define(total_size,array_size+gap_size+i_size+j_size+temp_size)
	define(alloc,-(16+total_size)&-16)
	define(dealloc,-alloc)

	// setting the size relative to frame record
	define(v_i,16)
	define(v_j,20)
	define(gap_s,24)
	define(temp_s,28)
	define(array_s,32)

unsorted:	.string "Unsorted array:\n"			// the string format to show the following values are unsorted
sorted:		.string "\nSorted array:\n"			// the string format to show the following values are sorted
output:		.string "v[%d]: %d\n"			 	// the string format used for printing out the values of the array
	
		.balign		4				// makes all the addresses divisible by 4 so they are aligned with the word length
		.global		main				// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
	stp		fp, lr, [sp, alloc]!			// stores the FP and LP in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP
	add 		array_base, fp, total_size		// adding FP and total_size and storing it in array_base (total array capacity)
	mov		index_i, 0				// setting the index value to 0
	str		index_i, [fp, v_i]			// store index_i in address FP
	b		test1 					// check loop test for this first loop in the program 
	
initialize: 
	bl 		rand					// call the function rand to generate pseudorandom numbers
	ldr		index_i, [fp, v_i]			// load index_i from FP
	and		w22, w0, 0x1FF				// AND w0 with 0x1FF and store the result in w22
	str		w22, [array_base, index_i, SXTW 2]	// store w22 in address array_base
	add		index_i, index_i, 1 			// increment array_index_r by 1 each iteration of the loop
	str		index_i, [fp, v_i]			// store index_i in address FP
	
test1:	
	cmp		index_i, size 				// check loop condition to see if array_index_r is less than 100
	b.lt		initialize				// if array_index_r is less than 100, execute the loop body again
	
	adrp		x0, unsorted				// first step in printing the unsorted prompt
	add		x0, x0, :lo12:unsorted			// second step in printing the unsorted prompt
	ldr		w1, [fp, v_i]				// loading register w1 with the address of FP
	ldr		w2, [array_base, index_i, SXTW 2]	// loading register w2 with with the address of array_base
	bl		printf					// calling the function printf to display output to screen
	mov		index_i, 0				// reset the index value to 0
	str		index_i, [fp, v_i]			// store index_i in address FP
	b		test2					// jump to label "test2"


	
	
loopunsorted:
	adrp		x0, output				// first step in printing the unsorted array values
	add		x0, x0, :lo12:output			// second step in printing the unsorted array values
	ldr		w1, [fp, v_i]				// loading register w1 with the address of FP
	ldr		w2, [array_base, index_i, SXTW 2]	// loading register w2 with the address of array_base
	bl		printf					// calling the function printf to display output to the screen 

	add 		index_i, index_i, 1			// incrementing the index by 1
	str		index_i, [fp, v_i]			// store index_i in address FP
	
test2:
	cmp		index_i, size				// loop test to see if index has reaching 100
	b.lt		loopunsorted				// if it is less than 100 iterate through "loopunsorted" again

reset1:	
	mov		gap, size				// setting gap equal to size
	lsr		gap, gap, 1				// dividing the value of gap by 2
	str		gap, [fp, gap_s]			// store gap in FP
	b		test3					// jump to label "test3"


	

	
shellsort1:
	ldr		gap, [fp, gap_s]			// load gap from FP
	str		gap, [fp, v_i]				// store gap in the address of v_i
	b		test4					// jump to label "test4"
	
shellsort2:
	ldr		index_i, [fp, v_i]			// load index_i from FP
	ldr		index_j, [fp, v_j]			// load index_j from FP
	ldr		gap, [fp, gap_s]			// load gap from FP
	sub		index_j, index_i, gap			// subtracting gap from index_i and storing the result in index_i
	str		index_j, [fp, v_j]			// store index_j in FP
	b		test5					// jump to label "test5"
	
shellsort3:
	ldr 		temp, [fp, temp_s]			// loading temp from FP
	ldr		index_j, [fp, v_j]			// loading index_j from FP
	ldr		w27, [array_base, index_j, SXTW 2]	// loading w27 into array_base, index_j
	str		w27, [fp, temp_s]			// storing w27 in temp_s
	ldr		gap, [fp, gap_s]			// loading gap from FP
	add		w25, index_j, gap			// adding gap and j and storing the result i w25
	ldr		w26, [array_base, w25, SXTW 2]		// loading w26 with array_base, w25 (gap + j)
	str		w26, [array_base, index_j, SXTW 2]	// storing w26 with array_base, index_j
	ldr 		temp, [fp, temp_s]			// loading temp from FP
	str		temp, [array_base, w25, SXTW 2]		// storing temp with array_base, w25
	sub		index_j, index_j, gap			// subtracting gap from index_j and storing the result in index_j
	str		index_j, [fp, v_j]			// storing index_j into FP

test5:
	ldr		index_j, [fp, v_j]			// loading index_j from FP
	cmp		index_j, 0				// comparing index_j with 0
	b.lt		incrementing				// if index_j is less than 0 jump to shellsort2
	ldr		index_j, [fp, v_j]			// loading index_j from FP
	ldr		gap, [fp, gap_s]			// loading gap from FP
	add		w26, index_j, gap			// adding index_j with gap and storing it in w26
	ldr		w28, [array_base, w26, SXTW 2]		// load register w28 with array_base, w26 (j + gap)
	ldr		w22, [array_base, index_j, SXTW 2]	// load register w22 with array_base, index_j
	cmp		w22, w28				// compare registers w26 and w27
	b.lt		shellsort3				// jump to label "shellsort3" if w22 is less than w23

incrementing:
	ldr		index_i, [fp, v_i]			// loading index_i from FP
	add		index_i, index_i, 1			// incrementing index_i by 1
	str		index_i, [fp, v_i]			// storing index_i in FP
	
test4:
	ldr		index_i, [fp, v_i]			// loading index_i in FP
	cmp		index_i, size				// comparing index_i with size
	b.lt		shellsort2				// if index index_i is less than size jump to shellsort2
	ldr		gap, [fp, gap_s]			// loading gap from FP
	lsr		gap, gap, 1				// dividing gap by 2 and storing the result in gap
	str		gap, [fp, gap_s]			// storing gap in FP
	
test3:
	ldr		gap, [fp, gap_s]			// loading gap from FP
	cmp		gap, 0					// comparing gap with 0	
	b.gt		shellsort1				// if gap is greater than 0 jump to shellsort1

reset2:	
	adrp		x0, sorted				// first step in printing the unsorted prompt	
	add		x0, x0, :lo12:sorted			// second step in printing the unsorted prompt
	ldr		w1, [fp, v_i]				// loading register w1 with the address of FP
	ldr		w2, [array_base, index_i, SXTW 2]	// loading register w2 with with the address of array_base
	bl		printf					// calling the function printf to display output to screen

	ldr		index_i, [fp, v_i]			// loading index_i from FP
	mov		index_i, 0				// reset the index value to 0
	str		index_i, [fp, v_i]			// store index_i in address FP
	b		test6					// jump to label "test6"
	

	


loopsorted:
	ldr		index_i, [fp, v_i]			// loading index_i from FP
	
	adrp		x0, output				// first step in printing the unsorted array values
	add		x0, x0, :lo12:output			// second step in printing the unsorted array values
	ldr		w1, [fp, v_i]				// loading register w1 with the address of FP
	ldr		w2, [array_base, index_i, SXTW 2]	// loading register w2 with the address of array_base
	bl		printf					// calling the function printf to display output to the screen 

	add 		index_i, index_i, 1			// incrementing the index by 1
	str		index_i, [fp, v_i]			// store index_i in address FP
	
test6:
	ldr		index_i, [fp, v_i]			// loading index_i from FP
	cmp		index_i, size				// loop test to see if index has reaching 100
	b.lt		loopsorted				// if it is less than 100 iterate through "loopunsorted" again
	
done:	ldp		x29, x30, [sp], dealloc			// restore sp to x29 and x30 then do sp +dealloc and set to sp
	ret							// return to the OS
