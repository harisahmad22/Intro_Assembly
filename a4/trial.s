// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #4

	// setting register values for FP and LR
	fp		.req	x29
	lr		.req	x30	

	// defining macros and the size of the variables
	
	

	// idek
	
	
	
	
	

	//printPyramid?
	name_s = 16
	p_s = 24
	name_size = 1
	p_size = 8
	
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

	// assembler equates for allocating memory from the stack
	
	
	

fmt1:	.string "Pyramid %s\n"	//name
fmt2:	.string "\tCenter = (%d, %d)\n" //p->center.x, p->center.y
fmt3:	.string "\tBase width = %d, Base length = %d\n" //p->base.width, p->base.length
fmt4:	.string "\tHeight = %d\n" // p->height
fmt5:	.string "\tVolume = %d\n\n" // p->volume
fmt6:	.string "Initial pyramid values:\n"
fmt7:	.string "\nNew pyramid values:\n"
fmt8:	.string "x8"
fmt9:	.string "x9"

		.balign		4				// makes all the addresses divisible by 4 so they are aligned with the word length
		.global		main				// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
	stp		fp, lr, [sp, -(16+pyramid_size+pyramid_size)&-16]!			// stores the FP and LP in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP

khafreMain:	
	mov 		w0, 10
	mov		w1, 9
	b 		newPyramid

next:
	mov		w0, 15
	mov		w1, 18
	b 		after

next2:	
	adrp		x0, fmt6
	add		x0, x0, :lo12:fmt6
	bl 		printf

	// do print function here.
	add		x0, fp, x8
	b 		printPyramid
	
done:
	ldp		fp, lr, [sp], --(16+pyramid_size+pyramid_size)&-16
	ret

	
	