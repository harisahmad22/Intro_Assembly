yValue:			.string "The current Y-value is: %d\n"
xValue:			.string "The current X-value is: %d\n"
maximum:		.string "The current maximum is: %d\n\n"

	.balign		4
	.global		main
main:	stp		x29, x30, [sp, -16]!
	mov		x29, sp

	mov		x19, 0 // setting an integer of value 0 (index start)
	mov 		x25, -10 // starting x-value (-10)

loop:   cmp		x19, 21 // comparing the starting value with 21 (should iterate 20x)
	b.ge		done // if the starting loop value is now greater than or equal to 11 move to "done:"

	mov 		x21, -3	      // setting x21 equal to -3 at the start of every loop iteration
	mul		x26, x25, x25 // cube the polynomial (1st step (square))
	mul		x26, x26, x25 // cube the polynomial (2nd step (cube))
	mul		x26, x26, x25 // multiply by the cubed number earlier (x^4)
	mul 		x26, x21, x26 // multiplication steps for the highest exponent (4) on the polynomial
	mov 		x24, x26      // setting x24 = to x26 (x24 = to the value of the first term)
	
	mov 		x21, 267      // setting x21 equal to 267
	mul 		x26, x25, x25 // multiplication steps for the second highest exponent (2(squaring)) 
	mul 		x26, x21, x26 
	add 		x24, x24, x26 // adding the multiplication result to the running total of the y-value
	
	mov 		x21, 47	      // setting x21 equal to 47
	mul		x26, x25, x21 // multiplication steps for the third highest exponent (1)
	add 		x24, x26, x24 // adding the multiplication result to the running total of the y-value
		
	add 		x24, x24, -43 // adding the running total of the y-value with -43

	adrp		x0, xValue		// adding the xValue string to x0
	add		x0, x0, :lo12:xValue
	mov 		x1, x25			// setting x1 to display the value of the current x-value
						// that the loop is iterating on
	bl		printf			// printing the full string + x-value to the screen

	adrp		x0, yValue		// adding the yValue string to x0
	add		x0, x0, :lo12:yValue
	mov		x1, x24			// setting x1 to display the value of the total y-value
						// at the current x-value that the loop is iterating on
	bl		printf			// printing the full string + y-value to the screen
	
	cmp 		x24, x20		// comparing x24 (y-value) to x-20
	b.le		increments		// if the x24 is less than or equal x20 go to label "increments"
	
newMaximum:	mov 	x20, x24
	
increments:	add 		x25, x25, 1 // adding 1 to the x value so it can go one-by-one from -10 to +10
		add		x19, x19, 1 // loop increments by 1 every time
		adrp		x0, maximum		// adding the maximum string to x0
		add		x0, x0, :lo12:maximum
		mov		x1, x20 		// setting x1 to display the value of the current maximum
		bl 		printf			// printing the full string + maximum value to the screen

		b		loop // go back to "test" (cycle through loop again)
	
done:	ldp		x29, x30, [sp], 16
	ret
