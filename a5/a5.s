	fp	.req	x29		// setting x29 to name fp
	lr	.req	x30		// setting x30 to name lr

			// define constant 20 = 20
			// define constant '0' = '0'
			// define constant '9' = '9'

			// define constant 100 = 100
			// define constant 100 = 100

				// define w19 to register w19
				// define w20 to register w20
				// define x21 to register x21
			// define w22 to register w22

pushString:		.string "Error: stack full\n"			// the string used in the "push" subroutine
popString:		.string "Error: stack empty\n"			// the string used in the "pop" subroutine
ungetchString:		.string "ungetch: too many characters\n"	// the string used in the "ungetch" subroutine

// the .data section
	.data
	.balign 8		// makes all the addresses divisible by 8
	.global sp_m		// global variable #1, sp_m
sp_m:	.word	0		// initializing sp_m to 0
	.global bufp		// global variable #2, bufp
bufp:	.word	0		// initializing bufp to 0

// the .bss section
	.bss
	.balign 8 		// makes all the addresses divisible by 8
	.global val		// unintialized array #1, val
val:	.skip	100*4		// size of array
	.global buf		// unintialized array #2, buf
buf:	.skip	100*1		// size of array

// the .text section
	.text
	.balign 4						// makes all the addresses divisible by 4 so they are aligned with the word length

	.global push
push:	stp		fp, lr, [sp, -16]!			// stores the fp and lr in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP

	adrp		x9, sp_m				// 1st step in getting global variable sp_m
	add		x9, x9, :lo12: sp_m			// 2nd step in getting global variable sp_m
	ldr		w10, [x9]				// w10 = sp_m		

	cmp 		w10, 100				// compare value of w10 with 100
	b.ge 		pushElse				// if greater than or rqual to jump to "else" label
						
	adrp		x11, val				// 1st step in getting global array val
	add		x11, x11, :lo12: val			// 2nd step in getting global array val

	str		w0, [x11, w10, SXTW 2]			// store val[sp]

	add		w10, w10, 1				// increment w10 by 1
	str		w10, [x9]				// store w10 in x9 address

	b		pushExit				// jump to label "pushExit"
pushElse:							
	adrp 		x0, pushString				// 1st step in printing the "pop" string
	add		x0, x0, :lo12: pushString		// 2nd step in printing the "pop" string
	bl 		printf					// call the print function

	bl 		clear					// call the clear function
							
	mov		x0, 0					// set x0 to 0
					
pushExit:
	ldp		fp, lr, [sp], 16			// deallocate memory from stack
	ret							// return subroutine

	


	.global 	pop					// the pseudo op which sets the start label to "pop" and makes sure that the "pop" label is linked
pop:	stp		fp, lr, [sp, -16]!			// stores the fp and lr in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP

	adrp		x9, sp_m				// 1st step in grabbing the global variable sp_m
	add		x9, x9, :lo12: sp_m			// 2nd step in grabbing the global variable sp_m
	ldr		w10, [x9]				// w10 = sp_m
	
	cmp		w10, 0					// compare w10 with 0
	b.le		popElse					// if w10 is less than 0, go to "else" label
		
	adrp		x11, val				// 1st step in grabbing the global variable val
	add		x11, x11, :lo12: val			// 2nd step in grabbing the global variable val
	
	sub 		w10, w10, 1				// decrement sp (w10) by 1
	str 		w10, [x9]				// store w10 back in the stack
	
	ldr		w0, [x11, w10, SXTW 2] 			// return val[sp]
	
	b		popExit					// jump to label "popExit"
popElse:		
	adrp 		x0, popString				// 1st step in printing the "popString" string
	add		x0, x0, :lo12: popString		// 2nd step in printing the "popString" string
	bl 		printf					// calling the printf function
	
	bl 		clear					// calling the clear function
					
	mov		x0, 0					// set x0 to 0

popExit:
	ldp		fp, lr, [sp], 16			// deallocate memory from stack
	ret							// return subroutine

	

	
	.global 	clear					// the pseudo op which sets the start label to "clear" and makes sure that the "clear" label is linked
clear:	stp		fp, lr, [sp, -16]!			// stores the fp and lr in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP
						
	adrp		x9, sp_m				// 1st step in grabbing the global variable sp_m
	add		x9, x9, :lo12: sp_m			// 2nd step in grabbing the global variable sp_m
	ldr		w10, [x9]				// w10 = sp_m

	mov		w10, 0					// w10 = 0
	str		w10, [x9]				// store the value of w10 in x9

clearExit:
	ldp		fp, lr, [sp], 16			// deallocate memory from stack
	ret							// return subroutine



	
	.global 	getop					// the pseudo op which sets the start label to "getop" and makes sure that the "getop" label is linked
	i_size = 4						// setting the size of the i variable
	c_size = 4						// setting the size of the c variable
	getopAlloc = -((16+i_size+c_size)&-16)			// amount of memory to allocate in this subroutine
	getopDealloc = -getopAlloc				// amount of memory to deallocate in this subroutine
	i_s = 16
	c_s = 20
getop:	stp		fp, lr, [sp, getopAlloc]!		// stores the fp and lr in the stack with two double spaces
	mov		fp, sp					// moves the SP to the LP

	mov		x21, x0					// set x21 equal to first function arg
	mov		w22, w1				// set w22 equal to second function arg

initialLoop:				
	bl		getch					// call the getch function
	mov 		w19, w0					// set w19 equal to the value attained from getch
	str 		w19, [fp, c_s]				// store the value of w19 in the stack
	
	cmp 		w19, ' '				// compare w19 with ' '
	b.eq		initialLoop				// if equal, go to label "initial loop"
	cmp		w19, '\t'				// compare w19 with '\t'
	b.eq		initialLoop				// if equal go to label "initial loop"
	cmp 		w19, '\n'				// compare w19 with '\n'
	b.eq		initialLoop				// if equal go to label "initial loop"

firstIfTest:
	cmp		w19, '0'				// compare w19 with '0'
	b.lt	 	firstIfBody				// if less than go to label "firstIfBody"
	cmp		w19, '9'				// compare w19 with '9'
	b.gt		firstIfBody				// if less than go to label "firstIfBody"

	b 		next					// jump to label "next"

firstIfBody:	
	mov 		w0, w19					// set w19 to be the returned value
	b		getopExit				// jump to label getopExit

next:
	mov		w9, 0					// set w9 to 0
	strb		w19, [x21, x9]				// store the value of c in the s array at index 0
	
	mov		w20, 1					// set w20 to 1
	str		w20, [fp, i_s]				// store the value of w20 in the stack
	b 		forLoopTest				// jump to label "forLoopTest"
	
forIfTest:
	cmp		w20, w22				// compare registers w20 and w22
	b.ge		endForIfLoop				// if the value in w20 is greater than the value in w22, go to label "endForIfLoop"
	
	strb		w19, [x21, w20, SXTW]			// store the value of c in the s array at index i

endForIfLoop:
	add		w20, w20, 1				// increment w20 by 1
	str		w20, [fp, i_s]				// store the value of w20 in the stack

forLoopTest:
	bl		getchar					// call function getchar
	mov		w19, w0					// set w19 to w0
	str		w19, [fp, c_s]				// store the value of w19 in the stack
	
	cmp		w19, '0'				// compare w19 with '0'
	b.lt		endForLoop				// if less than, go to label "endForLoop"
	cmp		w19, '9'				// compare w19 with '9'
	b.le		forIfTest				// if less than or equal to, go to label "forIfTest"

endForLoop:
	cmp		w20, w22				// compare registers w20 and w22
	b.ge		getopElse				// if the value in w20 is greater than the value in w22, go to label "getopElse"

	mov		w0, w19					// set the value w0 to the value in register w19
	bl		ungetch					// call function ungetch
	mov		w10, 0					// set w10 to 0

	strb		w10, [x21, w20, SXTW]			// store the value 0 into register x21 at index i
	mov		w0, '0'				// set the return value to the constant '0'
	b		getopExit				// jump to label getopExit

getopElse:
	cmp		w19, '\n'				// compare register w19 with '\n'
	b.eq		endWhileLoop				// if equal, go to label "endWhileLoop"

	cmp		w19, -1					// compare register w19 with -1
	b.eq		endWhileLoop				// if equal, go to lavel "endWhileLoop"
	
	bl		getchar					// call function getchar
	mov		w19, w0					// set w19 to w0
	str		w19, [fp, c_s]				// store the value of w19 in the stack
	b		getopElse				// jump to lavel getopElse

endWhileLoop:
	mov		w11, 0					// set w11 to 0
	sub		w22, w22, 1				// decrement w22 by 1
	strb		w11, [x21, w22, SXTW]			// set the value of array s at index lim (lim-1 now) to 0

	mov		w0, '9'				// set the return value to the constant '9'

getopExit:
	ldr		w19, [fp, c_s]				// load back the contents of register w19
	ldr		w20, [fp, i_s]				// load back the contents of register w20

	ldp		fp, lr, [sp], getopDealloc		// deallocate memory from stack
	ret							// return subroutine


	

	.global 	getch						// the pseudo op which sets the start label to "getch" and makes sure that the "getch" label is linked
getch:	stp		fp, lr, [sp, -16]!				// stores the fp and lr in the stack with two double spaces
	mov		fp, sp						// moves the SP to the LP

	adrp		x9, bufp					// 1st step in getting the global variable bufp
	add		x9, x9, :lo12: bufp				// 2nd step in getting the global variable bufp
	ldr		w10, [x9]					// loading bufp into register w10
								
	adrp 		x11, buf					// 1st step in getting the global array buf
	add		x11, x11, :lo12: buf				// 2nd step in getting the global array buf

	cmp 		w10, 0						// comparing bufp with 0
	b.le		getchElse					// if w10 (bufp) is less than or equal to 0 go to "else" label
						
	sub 		w10, w10, 1					// decrement w10 by 1
	str		w10, [x9]					// store w10 back into x9 address

	ldr		w0, [x11, w10, SXTW 2]				// return the array at index bufp

	b 		getchExit					// go to label getchExit

getchElse:
	bl 		getchar						// call function getchar

getchExit:
	ldp		fp, lr, [sp], 16				// deallocate memory from stack
	ret								// return subroutine



	
	.global 	ungetch						// the pseudo op which sets the start label to "ungetch" and makes sure that the "ungetch" label is linked
ungetch:
	stp		fp, lr, [sp, -16]!				// stores the fp and lr in the stack with two double spaces
	mov		fp, sp						// moves the SP to the LP

	adrp		x9, bufp					// 1st step in getting the global variable bufp
	add		x9, x9, :lo12: bufp				// 2nd step in getting the global variable bufp
	ldr		w10, [x9]					// loading bufp into register w10

	cmp 		w10, 100					// comparing bufp with 100
	b.le		ungetchElse					// if it is less than or equal to 100 go to "else" label

	adrp 		x0, ungetchString				// 1st step in printing the "ungetchString" string
	add		x0, x0, :lo12: ungetchString			// 2nd step in printing the "ungetchString" string
	bl 		printf						// calling the printf function
			
	b 		ungetchExit					// go to label ungetchExit

ungetchElse:
	adrp 		x11, buf					// 1st step in getting the global array buf
	add		x11, x11, :lo12: buf				// 2nd step in getting the global array buf
							
	str		w0, [x11, w10, SXTW 2]				// store buf[bufp]

	add		w10, w10, 1					// incremnt bufp by 1
	str		w10, [x9]					// store bufp back into x9 address
								
ungetchExit:	
	ldp		fp, lr, [sp], 16				// deallocate memory from stack
	ret								// return subroutine


