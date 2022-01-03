// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #4

	// setting register values for FP and LR
	fp		.req	x29
	lr		.req	x30	

	// defining macros and the size of the variables
	define(false,0)
	define(true,1)

	// idek
	define(khafre,x8)
	define(cheops,x9)
	define(width_r, w20)
	define(height_r, w21)
	define(length_r, w22)

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
	define(total_size,pyramid_size+pyramid_size)
	define(alloc,-(16+total_size)&-16)
	define(dealloc,-alloc)

fmt1:	.string "Pyramid %s\n"	//name
fmt2:	.string "\tCenter = (%d, %d)\n" //p->center.x, p->center.y
fmt3:	.string "\tBase width = %d, Base length = %d\n" //p->base.width, p->base.length
fmt4:	.string "\tHeight = %d\n" // p->height
fmt5:	.string "\tVolume = %d\n\n" // p->volume
fmt6:	.string "Initial pyramid values:\n"
fmt7:	.string "\nNew pyramid values:\n"
fmt8:	.string "khafre"
fmt9:	.string "cheops"

		.balign		4				// makes all the addresses divisible by 4 so they are aligned with the word length
		.global		main				// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
	stp		fp, lr, [sp, alloc]!			// stores the FP and LP in the stack with two double spaces
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
	add		x0, fp, khafre
	b 		printPyramid
	
done:
	ldp		fp, lr, [sp], dealloc
	ret

	define(p_base_r,x19)
	define(newPyramid_alloc,-(16+pyramid_size)&-16
	define(newPyramid_dealloc,-newPyramid_alloc)
	p_s = 24
newPyramid:	
	stp		fp, lr, [sp, newPyramid_alloc]!
	mov		fp, sp

	add		p_base_r, fp, p_s
	
	str		wzr, [p_base_r, coord_x] 		// p.x = 0	
	str		wzr, [p_base_r, coord_y] 		// p.y = 0

	ldr		x10, [p_base_r, coord_x]		// set in main
	str		x10, [khafre, coord_x]			// khafre.x = p.x
	ldr		x10, [p_base_r, coord_y]		// set in main
	str		x10, [khafre, coord_y			// khafre.y = p.y

	
	mov		width_r, w0				// width_r = 10
	ldr 		width_r, [p_base_r, size_width]		// set in main 
	str		width_r, [khafre, size_width] 		// khafre.width = width_r
	
	mov		length_r, w0				// length_r = 10
	ldr		length_r, [p_base_r, size_length]	// set in main
	str		length_r, [khafre, size_length]		// khafre.length = length_r

	mov		height_r, w1				// height_r = 9
	ldr		height_r, [p_base_r, pyr_height]	// set in main
	str		height_r, [khafre, pyr_height]		// khafre.height = height_r
	
	b 		next

after:	
	str		wzr, [p_base_r, coord_x] 		// p.x = 0	
	str		wzr, [p_base_r, coord_y] 		// p.y = 0

	ldr		x10, [p_base_r, coord_x]		// set in main
	str		x10, [cheops, coord_x]			// khafre.x = p.x
	ldr		x10, [p_base_r, coord_y]		// set in main
	str		x10, [cheops, coord_y			// khafre.y = p.y

	
	mov		width_r, w0				// width_r = 10
	ldr 		width_r, [p_base_r, size_width]		// set in main 
	str		width_r, [cheops, size_width] 		// khafre.width = width_r
	
	mov		length_r, w0				// length_r = 10
	ldr		length_r, [p_base_r, size_length]	// set in main
	str		length_r, [cheops, size_length]		// khafre.length = length_r

	mov		height_r, w1				// height_r = 9
	ldr		height_r, [p_base_r, pyr_height]	// set in main
	str		height_r, [cheops, pyr_height]		// khafre.height = height_r
	
	b 		next2

	
	ldp		fp, lr, [sp], newPyramid_dealloc
	ret

	b 		done
