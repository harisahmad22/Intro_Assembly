// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #5

	fp	.req	x29		// setting x29 to name fp
	lr	.req	x30		// setting x30 to name lr

	define(MAXOP,20)		// define constant MAXOP = 20
	define(NUMBER,'0')		// define constant NUMBER = '0'
	define(TOOBIG,'9')		// define constant TOOBIG = '9'

	define(MAXVAL,100)		// define constant MAXVAL = 100
	define(BUFSIZE,100)		// define constant BUFSIZE = 100

	define(c_r,w19)			// define c_r to register w19
	define(i_r,w20)			// define i_r to register w20
	define(s_r,x21)			// define s_r to register x21
	define(lim_r,w22)		// define lim_r to register w22

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

	cmp 		w10, MAXVAL				// compare value of w10 with MAXVAL
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

	mov		s_r, x0					// set s_r equal to first function arg
	mov		lim_r, w1				// set lim_r equal to second function arg

initialLoop:				
	bl		getch					// call the getch function
	mov 		c_r, w0					// set c_r equal to the value attained from getch
	str 		c_r, [fp, c_s]				// store the value of c_r in the stack
	
	cmp 		c_r, ' '				// compare c_r with ' '
	b.eq		initialLoop				// if equal, go to label "initial loop"
	cmp		c_r, '\t'				// compare c_r with '\t'
	b.eq		initialLoop				// if equal go to label "initial loop"
	cmp 		c_r, '\n'				// compare c_r with '\n'
	b.eq		initialLoop				// if equal go to label "initial loop"

firstIfTest:
	cmp		c_r, '0'				// compare c_r with '0'
	b.lt	 	firstIfBody				// if less than go to label "firstIfBody"
	cmp		c_r, '9'				// compare c_r with '9'
	b.gt		firstIfBody				// if less than go to label "firstIfBody"

	b 		next					// jump to label "next"

firstIfBody:	
	mov 		w0, c_r					// set c_r to be the returned value
	b		getopExit				// jump to label getopExit

next:
	mov		w9, 0					// set w9 to 0
	strb		c_r, [s_r, x9]				// store the value of c in the s array at index 0
	
	mov		i_r, 1					// set i_r to 1
	str		i_r, [fp, i_s]				// store the value of i_r in the stack
	b 		forLoopTest				// jump to label "forLoopTest"
	
forIfTest:
	cmp		i_r, lim_r				// compare registers i_r and lim_r
	b.ge		endForIfLoop				// if the value in i_r is greater than the value in lim_r, go to label "endForIfLoop"
	
	strb		c_r, [s_r, i_r, SXTW]			// store the value of c in the s array at index i

endForIfLoop:
	add		i_r, i_r, 1				// increment i_r by 1
	str		i_r, [fp, i_s]				// store the value of i_r in the stack

forLoopTest:
	bl		getchar					// call function getchar
	mov		c_r, w0					// set c_r to w0
	str		c_r, [fp, c_s]				// store the value of c_r in the stack
	
	cmp		c_r, '0'				// compare c_r with '0'
	b.lt		endForLoop				// if less than, go to label "endForLoop"
	cmp		c_r, '9'				// compare c_r with '9'
	b.le		forIfTest				// if less than or equal to, go to label "forIfTest"

endForLoop:
	cmp		i_r, lim_r				// compare registers i_r and lim_r
	b.ge		getopElse				// if the value in i_r is greater than the value in lim_r, go to label "getopElse"

	mov		w0, c_r					// set the value w0 to the value in register c_r
	bl		ungetch					// call function ungetch
	mov		w10, 0					// set w10 to 0

	strb		w10, [s_r, i_r, SXTW]			// store the value 0 into register s_r at index i
	mov		w0, NUMBER				// set the return value to the constant NUMBER
	b		getopExit				// jump to label getopExit

getopElse:
	cmp		c_r, '\n'				// compare register c_r with '\n'
	b.eq		endWhileLoop				// if equal, go to label "endWhileLoop"

	cmp		c_r, -1					// compare register c_r with -1
	b.eq		endWhileLoop				// if equal, go to lavel "endWhileLoop"
	
	bl		getchar					// call function getchar
	mov		c_r, w0					// set c_r to w0
	str		c_r, [fp, c_s]				// store the value of c_r in the stack
	b		getopElse				// jump to lavel getopElse

endWhileLoop:
	mov		w11, 0					// set w11 to 0
	sub		lim_r, lim_r, 1				// decrement lim_r by 1
	strb		w11, [s_r, lim_r, SXTW]			// set the value of array s at index lim (lim-1 now) to 0

	mov		w0, TOOBIG				// set the return value to the constant TOOBIG

getopExit:
	ldr		c_r, [fp, c_s]				// load back the contents of register c_r
	ldr		i_r, [fp, i_s]				// load back the contents of register i_r

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

	cmp 		w10, BUFSIZE					// comparing bufp with BUFSIZE
	b.le		ungetchElse					// if it is less than or equal to BUFSIZE go to "else" label

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


