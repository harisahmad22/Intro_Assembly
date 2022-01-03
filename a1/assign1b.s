// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #1

yValueString:		.string "The current Y-value is: %d\n"
xValueString:		.string "The current X-value is: %d\n"
maximumString:		.string "The current maximum is: %d\n\n"

	.balign		4
	.global		main
main:	stp		x29, x30, [sp, -16]!
	mov		x29, sp

	
	
	
	
	
	
	
	mov		x19, 0 // setting an integer of value 0 (x19 start)
	mov 		x25, -10 // starting x25 (-10)

loop:	mov 		x21, -3	      // setting x21 equal to -3 at the start of every loop iteration
	mul		x26, x25, x25 // cube the polynomial (1st step (square))
	mul		x26, x26, x25  // cube the polynomial (2nd step (cube))
	mul		x26, x26, x25  // multiply by the cubed number earlier (x^4)
	mul 		x26, x21, x26 // multiplication steps for the highest exponent (4) on the polynomial
	mov 		x24, x26     // setting x24 = to x26 (x24 = to the value of the first term)
	
	mov 		x21, 267        // setting x21 equal to 267
	mul 		x26, x25, x25 // multiplication steps for the second highest exponent (2(squaring)) 
	madd		x24, x26, x21, x24	
	
	mov 		x21, 47		        // setting x21 equal to 47
	madd 		x24, x21, x25, x24
		
	add 		x24, x24, -43 // adding the running total of the y-value with -43

	adrp		x0, xValueString	// adding the x25 string to x0
	add		x0, x0, :lo12:xValueString
	mov 		x1, x25		// setting x1 to display the value of the current x25
						// that the loop is iterating on
	bl		printf			// printing the full string + x25 to the screen

	adrp		x0, yValueString	// adding the yValue string to x0
	add		x0, x0, :lo12:yValueString
	mov		x1, x24	// setting x1 to display the value of the total y-value
						// at the current x25 that the loop is iterating on
	bl		printf			// printing the full string + y-value to the screen
	
	cmp 		x24, x20	// comparing x24 (current y-value) to x20
	b.le		increments		// if the x24 is less than or equal x20 go to label "increments"
	
newMaximum:	mov 	x20, x24
	
increments:	add 		x25, x25, 1 // adding 1 to the x value so it can go one-by-one from -10 to +10
		add		x19, x19, 1 // loop increments by 1 every time

		adrp		x0, maximumString	// adding the x20 string to x0
		add		x0, x0, :lo12:maximumString
		mov		x1, x20 		// setting x1 to display the value of the current x20
		bl 		printf			// printing the full string + x20 value to the screen

		cmp		x19, 21 // comparing the starting value with 21 (should iterate 20x)
		b.ge		done // if the starting loop value is now greater than or equal to 11 move to "done:"
	
		b		loop // go back to "test" (cycle through loop again)
	
done:	ldp		x29, x30, [sp], 16
	ret
