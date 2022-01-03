// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #2

	define(x_var,w19)					// setting register w19 to variable name "x_var"
	define(y_var,w20)					// setting register w20 to variable name "y_var"
	define(t1,w21)						// setting register w21 to variable name "t1"
	define(t2,w22)						// setting register w22 to variable name "t2"
	define(t3,w23)						// setting register w23 to variable name "t3"
	define(t4,w24)						// setting register w24 to variable name "t4"

output:	.string "Original: 0x%08X	Reversed: 0x%08X\n" 	// the string format used for printing the original
								// and reversed values of the given value
	
	.balign		4					// makes all the addresses divisible by 4 so they are aligned with the word length
	.global		main					// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
step1:	
	stp		x29, x30, [sp, -16]!			// stores the FP and LP in the stock with two double spaces
	mov		x29, sp					// moves the SP to the FP

	mov 		x_var, 0x01FF01FF			// initializing the variable x_var with the value 0x07FC07FC 
	and 		t1, x_var, 0x55555555			// using the bitwise logical AND instruction on x_var and 0x55555555 and storing the result in t1
	lsl		t1, t1, 1				// using the bitwise shift instruction LSL on t1 to shift 1 to the left and storing the result in t1

	lsr 		t2, x_var, 1				// using the bitwise shift instruction LSR on t2 to shift 1 to the right and storing the result in t2 
	and 		t2, t2, 0x55555555			// using the bitwise logical AND insruction on t2 and 0x55555555 and storing the result in t2
	orr 		y_var, t1, t2				// using the bitwise logical ORR instruction on t1 and t2 and storing the result in y_var

step2:	
	and 		t1, y_var, 0x33333333			// using the bitwise logical AND instruction on y_var and 0x33333333 and storing the result in t1
	lsl		t1, t1, 2				// using the bitwise shift instruction LSL on t1 to shift 2 to the left and storing the result in t1

	lsr		t2, y_var, 2				// using the bitwise shift instruction LSR on y_var to shift 2 to the right and storing the result in t2
	and 		t2, t2, 0x33333333			// using the bitwise logical AND instruction on t2 and 0x33333333 and storing the result in t2
	orr		y_var, t1, t2				// using the bitwise logical ORR instruction on t1 and t2 and storing the result in y_var

step3:	
	and 		t1, y_var, 0x0F0F0F0F			// using the bitwise logical AND instruction on y_var and 0x0F0F0F0F and storing the result in t1
	lsl		t1, t1, 4				// using the bitwise shift instruction on t1 to shift 4 to the left and storing the result in t1

	lsr		t2, y_var, 4				// using the bitwise shift instruction on y_var to shift 4 to the right and storing the result in t2
	and		t2, t2, 0x0F0F0F0F			// using the bitwise logical AND instruction on t2 and 0x0F0F0F0F and storing the result in t2
	orr		y_var, t1, t2				// using the bitwise logical ORR instruction on t1 and t2 and storing the result in y_var

step4:	
	lsl		t1, y_var, 24				// using the bitwise shift instruction LSL on y_var to shift 24 to the left and storing the result in t1
				
	and		t2, y_var, 0xFF00			// using the bitwise logical AND instruction on y_var and 0xFF00 and storing the result in t2
	lsl		t2, t2, 8				// using the bitwise shift instruction LSL on t2 to shift 8 to the left and storing the result in t2

	lsr		t3, y_var, 8				// using the bitwise shift instruction LSR on y_var to shift 8 to the right and storing the result in t3
	and		t3, t3, 0xFF00				// using the bitwise logical AND instruction on t3 and 0xFF00 and storing the result 

	lsr		t4, y_var, 24				// using the bitwise shift instruction LSR on y_var to shift 24 to the right and storing the result in t4

	orr		t1, t1, t2				// using the bitwise logical ORR instruction on t1 and t2 and storing the result in t1
	orr		t3, t3, t4				// using the bitwise logical ORR instruction on t3 and t4 and storing the result in t3
	orr		y_var, t1, t3				// using the bitwise logical ORR instruction on t1 and t3 and storing the result in y_var

print:	
	adrp		x0, output				// adrp sets our var to x0 without lower 12 bits
	add		w0, w0, :lo12: output			// to add the lower 12 bits of our variable
	mov		w1, x_var				// set w1 to the value of the x_var
	mov 		w2, y_var				// set w2 to the value of the y_var
	bl		printf					// branch to a label printf
	
done:	ldp		x29, x30, [sp], 16			// restore sp to x29 and x30 then do sp +16 and set to sp
	ret							// return to the OS

	
