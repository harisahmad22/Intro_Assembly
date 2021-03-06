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

	define(counter,x19)
	define(xValue,x25)
	define(runningTotal,x24)
	define(constants,x21)
	define(maximum,x20)
	define(terms,x26)
	
	mov		counter, 0 // setting an integer of value 0 (counter start)
	mov 		xValue, -10 // starting xValue (-10)

loop:	mov 		constants, -3	      // setting constants equal to -3 at the start of every loop iteration
	mul		terms, xValue, xValue // cube the polynomial (1st step (square))
	mul		terms, terms, xValue  // cube the polynomial (2nd step (cube))
	mul		terms, terms, xValue  // multiply by the cubed number earlier (x^4)
	mul 		terms, constants, terms // multiplication steps for the highest exponent (4) on the polynomial
	mov 		runningTotal, terms     // setting runningTotal = to terms (runningTotal = to the value of the first term)
	
	mov 		constants, 267        // setting constants equal to 267
	mul 		terms, xValue, xValue // multiplication steps for the second highest exponent (2(squaring)) 
	madd		runningTotal, terms, constants, runningTotal	
	
	mov 		constants, 47		        // setting constants equal to 47
	madd 		runningTotal, constants, xValue, runningTotal
		
	add 		runningTotal, runningTotal, -43 // adding the running total of the y-value with -43

	adrp		x0, xValueString	// adding the xValue string to x0
	add		x0, x0, :lo12:xValueString
	mov 		x1, xValue		// setting x1 to display the value of the current xValue
						// that the loop is iterating on
	bl		printf			// printing the full string + xValue to the screen

	adrp		x0, yValueString	// adding the yValue string to x0
	add		x0, x0, :lo12:yValueString
	mov		x1, runningTotal	// setting x1 to display the value of the total y-value
						// at the current xValue that the loop is iterating on
	bl		printf			// printing the full string + y-value to the screen
	
	cmp 		runningTotal, maximum	// comparing runningTotal (current y-value) to maximum
	b.le		increments		// if the runningTotal is less than or equal maximum go to label "increments"
	
newMaximum:	mov 	maximum, runningTotal
	
increments:	add 		xValue, xValue, 1 // adding 1 to the x value so it can go one-by-one from -10 to +10
		add		counter, counter, 1 // loop increments by 1 every time

		adrp		x0, maximumString	// adding the maximum string to x0
		add		x0, x0, :lo12:maximumString
		mov		x1, maximum 		// setting x1 to display the value of the current maximum
		bl 		printf			// printing the full string + maximum value to the screen

		cmp		counter, 21 // comparing the starting value with 21 (should iterate 20x)
		b.ge		done // if the starting loop value is now greater than or equal to 11 move to "done:"
	
		b		loop // go back to "test" (cycle through loop again)
	
done:	ldp		x29, x30, [sp], 16
	ret

	
