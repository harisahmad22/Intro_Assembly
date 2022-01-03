// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #2

						// setting register w19 to variable name "w19"
						// setting register w20 to variable name "w20"
							// setting register w21 to variable name "w21"
							// setting register w22 to variable name "w22"
							// setting register w23 to variable name "w23"
							// setting register w24 to variable name "w24"

output:	.string "Original: 0x%08X	Reversed: 0x%08X\n" 	// the string format used for printing the original
								// and reversed values of the given value
	
	.balign		4					// makes all the addresses divisible by 4 so they are aligned with the word length
	.global		main					// the pseudo op which sets the start label to main and makes sure that the main label is linked
	
main:
step1:	
	stp		x29, x30, [sp, -16]!			// stores the FP and LP in the stock with two double spaces
	mov		x29, sp					// moves the SP to the FP

	mov 		w19, 0x7F807F80			// initializing the variable w19 with the value 0x07FC07FC 
	and 		w21, w19, 0x55555555			// using the bitwise logical AND instruction on w19 and 0x55555555 and storing the result in w21
	lsl		w21, w21, 1				// using the bitwise shift instruction LSL on w21 to shift 1 to the left and storing the result in w21

	lsr 		w22, w19, 1				// using the bitwise shift instruction LSR on w22 to shift 1 to the right and storing the result in w22 
	and 		w22, w22, 0x55555555			// using the bitwise logical AND insruction on w22 and 0x55555555 and storing the result in w22
	orr 		w20, w21, w22				// using the bitwise logical ORR instruction on w21 and w22 and storing the result in w20

step2:	
	and 		w21, w20, 0x33333333			// using the bitwise logical AND instruction on w20 and 0x33333333 and storing the result in w21
	lsl		w21, w21, 2				// using the bitwise shift instruction LSL on w21 to shift 2 to the left and storing the result in w21

	lsr		w22, w20, 2				// using the bitwise shift instruction LSR on w20 to shift 2 to the right and storing the result in w22
	and 		w22, w22, 0x33333333			// using the bitwise logical AND instruction on w22 and 0x33333333 and storing the result in w22
	orr		w20, w21, w22				// using the bitwise logical ORR instruction on w21 and w22 and storing the result in w20

step3:	
	and 		w21, w20, 0x0F0F0F0F			// using the bitwise logical AND instruction on w20 and 0x0F0F0F0F and storing the result in w21
	lsl		w21, w21, 4				// using the bitwise shift instruction on w21 to shift 4 to the left and storing the result in w21

	lsr		w22, w20, 4				// using the bitwise shift instruction on w20 to shift 4 to the right and storing the result in w22
	and		w22, w22, 0x0F0F0F0F			// using the bitwise logical AND instruction on w22 and 0x0F0F0F0F and storing the result in w22
	orr		w20, w21, w22				// using the bitwise logical ORR instruction on w21 and w22 and storing the result in w20

step4:	
	lsl		w21, w20, 24				// using the bitwise shift instruction LSL on w20 to shift 24 to the left and storing the result in w21
				
	and		w22, w20, 0xFF00			// using the bitwise logical AND instruction on w20 and 0xFF00 and storing the result in w22
	lsl		w22, w22, 8				// using the bitwise shift instruction LSL on w22 to shift 8 to the left and storing the result in w22

	lsr		w23, w20, 8				// using the bitwise shift instruction LSR on w20 to shift 8 to the right and storing the result in w23
	and		w23, w23, 0xFF00				// using the bitwise logical AND instruction on w23 and 0xFF00 and storing the result 

	lsr		w24, w20, 24				// using the bitwise shift instruction LSR on w20 to shift 24 to the right and storing the result in w24

	orr		w21, w21, w22				// using the bitwise logical ORR instruction on w21 and w22 and storing the result in w21
	orr		w23, w23, w24				// using the bitwise logical ORR instruction on w23 and w24 and storing the result in w23
	orr		w20, w21, w23				// using the bitwise logical ORR instruction on w21 and w23 and storing the result in w20

print:	
	adrp		x0, output				// adrp sets our var to x0 without lower 12 bits
	add		w0, w0, :lo12: output			// to add the lower 12 bits of our variable
	mov		w1, w19				// set w1 to the value of the w19
	mov 		w2, w20				// set w2 to the value of the w20
	bl		printf					// branch to a label printf
	
done:	ldp		x29, x30, [sp], 16			// restore sp to x29 and x30 then do sp +16 and set to sp
	ret							// return to the OS

	
