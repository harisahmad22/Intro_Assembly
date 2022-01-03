// Haris Ahmad
// 30088192
// haris.ahmad1@ucalgary.ca
// assignment #6

    fp	.req	x29		                                        // setting x29 to name fp
    lr	.req	x30		                                        // setting x30 to name lr

    INCREMENT = 5                                                       // How much to increment by
    LOWER_MAX = -95                                                     // Lower limit value
    UPPER_MAX = +95                                                     // Upper limit value

	
    buf_size = 8                                                        // Buffer for reading 8 byte floats
    buf_s = 16                                                          // Buffer offset in memory
                        
    alloc = -(16 + buf_size) & -16                                      // Allocation of memory calculation for main
    dealloc = -alloc                                                    // Deallocation of memory calucation for main

    define(value_r,w19)                                                 // Define register for value
    define(fd_r,w20)                                                    // Define register for fd
    define(argc_r,w21)                                                  // Define register for argc
    define(argv_r,x22)                                                  // Define register for argv
    define(buf_base_r,x23)                                              // Define register for buf base
    define(nread_r,x24)                                                 // Define register for nread

// The strings used to display the output to the user
fmt_abort:          .string "Can't open file for writing.\n"
fmt_error:          .string "Error writing file.\n"
fmt_opening:        .string "\nOpening from file: %s\n"
fmt_notopen:        .string "Error: Incorrect number of arguments. Usage: ./a6 <filename.bin>\n"
fmt_end:            .string "\nEnd of file reached.\n\n"
fmt_labels:         .string "\n       x:             arctan(x):   \n===================================\n"
fmt_x:              .string " %.10f   "                              
fmt_x2:             .string "  %.10f    "                               
fmt_arctan:         .string "   %.10f\n"     

    .data                                                                // Establishing the .data section
    .balign 8                                                            // Align by 8 bits
stop: 	            .double 0r1.0e-13                                    // ending series comparison value
temp_m:             .double 0r0.0                                        // Initialize temp variable
divnum_m:           .double 0r100.0                                      // Dividing by 100 value
zero_m:             .double 0r0.0                                        // Define variable for 0

    .text                                                                // Establishing the .text section
    .global main                                                         // The pseudo op which sets the start label to "main" and makes sure that the "main" label is linked
    .balign 4                                                            // Align by 4 bits
main:
		    stp  fp, lr, [sp, alloc]!                            // Allocate memory for main()
                    mov  fp, sp                                          // setting FP to SP

                    mov  argc_r, w0                                      // Set argc_r to register w0
                    mov  argv_r, x1                                      // Set argv_r to register x1
                    cmp  argc_r, 2                                       // Compare argc_r with 2
                    b.eq continue                                        // If equal branch to continue
                    
                    adrp x0, fmt_notopen                                 // Print string fmt_notopen                                    
                    add  x0, x0, :lo12:fmt_notopen
                    bl 	 printf                                          // Calling the print function to print the fmt_notopen string
                    b 	 end                                             // Then branch to end program

continue:
		    adrp x0, fmt_opening                                 // Print string fmt_opening
                    add  x0, x0, :lo12:fmt_opening
                    ldr  x1, [argv_r, 8]                                 // Load what file into x1
                    bl 	 printf                                          // Calling the print function to print the fmt_opening string

                    mov  x0, -100                                        // setting x0 to -100
                    ldr  x1, [argv_r, 8]                                 // Load argv_r into x1
                    
                    mov  w2, 0                                           // set w2 to 0 (other argument)
                    mov  w3, 0                                           // set w3 to 0 (other argument)
                    mov  x8, 56                                          // Openat I/O request
                    
                    svc  0                                               // Call system function
                    mov  fd_r, w0                                        // Record file descriptor

                    cmp  fd_r, 0                                         // error check
                    b.ge success                                         // If opened successfully, jump to success label

                    adrp x0, fmt_abort                                   // Printing abort string
                    add  x0, x0, :lo12:fmt_abort
                    bl   printf                                          // Calling the print function to print the fmt_abort string
                   
                    mov  x0, -1                                          // return -1
                    b    end                                             // Branch to end label

success:
		    add  buf_base_r, fp, buf_s                           // Calculate base address of buf

                    adrp x0, fmt_labels                                  // Printing the x and arctan(x) label
                    add  x0, x0, :lo12:fmt_labels
                    bl   printf                                          // Calling the print function to print the fmt_head string

                    mov  value_r, LOWER_MAX                              // Value = LOWER_MAX
                    b 	 test                                            // Branch to test label

loop:
		    mov  w0, fd_r                                        // 1st arg (fd)
                    mov  x1, buf_base_r                                  // 2nd arg (buf)
                    mov  w2, buf_size                                    // 3rd arg (n)
                    mov  x8, 63                                          // Read I/O request
                    
                    svc  0                                               // Call system function
                    mov  nread_r, x0                                     // Record the number of bytes read

                    cmp  nread_r, buf_size                               // Compare nread_r and buf_size
                    b.ne exit                                            // If nread_r != 8 just to exit label

                    ldr  d0, [buf_base_r]                                // Load x into d0

                    adrp x10, zero_m                                     // Get address of variable holding 0.0
                    add  x0, x10, :lo12:zero_m
                    ldr  d14, [x10]                                      // Load d14 with x10

                    fcmp d0, d14                                         // Compare x and 0.0
                    b.ge extra_space                                     // If x >= 0 branch to extra_space label

                    adrp x0, fmt_x                                       // Otherwise print x as a negative value
                    add  x0, x0, :lo12:fmt_x
                    bl 	 printf                                          // Calling the print function to print the fmt_x string
                    b 	 temp_div                                        // Branch to temp_div label

extra_space:
		    adrp x0, fmt_x2                                      // Add additional space to print statement
                    add  x0, x0, :lo12:fmt_x2    
                    bl 	 printf                                          // Calling the print function to print fmt_x2 string

temp_div:
		    adrp x10, temp_m                                     // Get address of temp_m in x10
                    add  x10, x10, :lo12:temp_m
                    ldr  d0, [x10]                                       // Load x10 into d0

                    scvtf d1, value_r                                    // Convert value into a signed floating point number and store in d1
                    
                    adrp x10, divnum_m                                   // Get address of divnum_m in x10
                    add  x10, x10, :lo12:divnum_m
                    ldr  d2, [x10]                                       // Load x10 into d2

                    fdiv d0, d1, d2                                      // temp = value/100

                    bl   arctan                                          // Call the arctan subroutine

                    adrp x0, fmt_arctan                                  // Setup print for arctan(x)
                    add  x0, x0, :lo12:fmt_arctan
                    bl   printf                                          // Calling the print function to print the fmt_arctan string

                    add  value_r, value_r, INCREMENT                     // value += INCREMENT

test:
		    cmp  value_r, UPPER_MAX                              // Compare value and UPPER_MAX
                    b.le loop                                            // If value <= UPPER_MAX jump to loop label

exit:
		    adrp x0, fmt_end                                     // Printing the fmt_end string to the user
                    add  x0, x0, :lo12:fmt_end
                    bl   printf                                          // Calling the print function to print the fmt_end string

                    mov  w0, fd_r                                        // 1st arg (fd)
                    mov  x8, 57                                          // Close I/O request
                    svc  0                                               // Call system function

end:
        	    ldp  fp, lr, [sp], dealloc                           // Deallocate memory for main
                    ret                                                	 // Return suboutine



    .balign 4                                                            // Align by 4 bits
    .global arctan                                                       // The pseudo op which sets the start label to "arctan" and makes sure that the "arctan" label is linked
arctan:
		    stp  fp, lr, [sp, -16]!                              // Memory allocation for subroutine
                    mov  fp, sp                                          // Set FP to SP

                    fmov d9, d0                                          // Move input from d0 to d9

                    adrp x10, stop 	                                 // Get address of stop
                    add  x10, x10, :lo12:stop
                    ldr  d10, [x10]                                      // load x10 into d10

                    adrp x10, zero_m                                     // Get address of zero_m
                    add  x0, x10, :lo12:zero_m
                    ldr  d15, [x10]                                      // Move 0 into d15
                    ldr  d14, [x10]                                      // Move 0 into d14

                    mov  w11, 1                                          // initialize w11 (counter) to 1

                    fmov d12, 1.0                                        // n=d12 and initialized to 1.0

arc_loop:
        	    cmp  w11, 1                                          // Compare w11 to 1
                    b.gt next1	                                         // If greater than 1 then jump to next1 label

                    fmov d13, d9                                         // Set d13 to d9
                    fmov d2, d13                                         // Set d2 to d13
                    b    arc_contd					 // jump to label arc_contd

next1:
		    fmov d13, d2                                         // reload value of d13 (x)                              
                    fmul d13, d13, d9                                    // mul d13 by d9 and store in d13
        	    fmul d13, d13, d9                                    // mul d13 by d9 and store in d13
	
                    fneg d13, d13                                        // negate x (d13)
                    fmov d2, d13                                         // save value x^n to d2
                    fdiv d13, d13, d12                                   // divide d13 by d12 and store in d13

arc_contd:
		    fadd d15, d15, d13                                   // add d13 to d15 and store in d15 (arctan(x))
                    add  w11, w11, 1                                     // Increment w11 by 1
                    fmov d1, 2.0                                         // Move 2.0 to d1
                    fadd d12, d12, d1                                    // increment n by d1(2)

                    fcmp d13, d14                                        // compare d13 with d14
                    b.gt check 	                                         // If positve (d13 greater than d14), branch to check

                    fneg d13, d13                                        // Negate it (make positive)
                    fcmp d13, d10                                        // Compare d13 with d10 (1.e-13)
                    fneg d13, d13                                        // Negate d13 (original sign)
                    b.gt arc_loop                                        // If d13 (x^n/n) is greater than 1.0e-13, jump to arc_loop label
                    b 	 arc_exit                                        // Otherwise jump to arc_exit

check:
		    fcmp d13, d10                                        // Compare d13 with d10 (1.e-13)
                    b.gt arc_loop                                        // If d13 (x^n/n) is greater than 1.0e-13, jump to arc_loop label

arc_exit:									
		    fmov d0, d15                                         // Return d15 (arctan(x)) value
	
                    ldp	 fp, lr, [sp], 16                                // Deallocate memory from stack
                    ret                                                  // Return subroutine

