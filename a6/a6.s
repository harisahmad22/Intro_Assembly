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

                                                     // Define register for value
                                                        // Define register for fd
                                                      // Define register for argc
                                                      // Define register for argv
                                                  // Define register for buf base
                                                     // Define register for nread

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
main:               stp  fp, lr, [sp, alloc]!                            // Allocate memory for main()
                    mov  fp, sp                                          // setting FP to SP

                    mov  w21, w0                                      // Set w21 to register w0
                    mov  x22, x1                                      // Set x22 to register x1
                    cmp  w21, 2                                       // Compare w21 with 2
                    b.eq continue                                        // If equal branch to continue
                    
                    adrp x0, fmt_notopen                                 // Print string fmt_notopen                                    
                    add  x0, x0, :lo12:fmt_notopen
                    bl 	 printf                                          // Calling the print function to print the fmt_notopen string
                    b 	 end                                             // Then branch to end program

continue:	    adrp x0, fmt_opening                                 // Print string fmt_opening
                    add  x0, x0, :lo12:fmt_opening
                    ldr  x1, [x22, 8]                                 // Load what file into x1
                    bl 	 printf                                          // Calling the print function to print the fmt_opening string

                    mov  x0, -100                                        // setting x0 to -100
                    ldr  x1, [x22, 8]                                 // Load x22 into x1
                    
                    mov  w2, 0                                           // set w2 to 0 (other argument)
                    mov  w3, 0                                           // set w3 to 0 (other argument)
                    mov  x8, 56                                          // Openat I/O request
                    
                    svc  0                                               // Call system function
                    mov  w20, w0                                        // Record file descriptor

                    cmp  w20, 0                                         // error check: branch over
                    b.ge success                                         // If file opened successfully, jump to success

                    adrp x0, fmt_abort                                   // Printing abort string
                    add  x0, x0, :lo12:fmt_abort
                    bl   printf                                          // Calling the print function to print the fmt_abort string
                   
                    mov  x0, -1                                          // return -1
                    b    end                                             // Branch to end

success:            add  x23, fp, buf_s                           // Calculate base address of buf

                    adrp x0, fmt_labels                                  // Printing header
                    add  x0, x0, :lo12:fmt_labels
                    bl   printf                                          // Calling the print function to print the fmt_head string

                    mov  w19, LOWER_MAX                              // Value = LOWER_MAX
                    b 	 test                                            // Branch to test label

loop:               mov  w0, w20                                        // 1st arg (fd)
                    mov  x1, x23                                  // 2nd arg (buf)
                    mov  w2, buf_size                                    // 3rd arg (n)
                    mov  x8, 63                                          // Read I/O request
                    
                    svc  0                                               // Call system function
                    mov  x24, x0                                     // Record the number of bytes read

                    cmp  x24, buf_size                               // Compare number of bytes read and 8
                    b.ne exit                                            // If nread != 8 exit the loop

                    ldr  d0, [x23]                                // Load x into d0

                    adrp x10, zero_m                                     // Get address of variable holding 0.0
                    add  x0, x10, :lo12:zero_m
                    ldr  d14, [x10]                                      // Load d14 with 0.0

                    fcmp d0, d14                                         // Compare x and 0.0 (Checking if positive for negative for printing lined up columns)
                    b.ge print_space                                     // If x >= 0 branch to print_space

                    adrp x0, fmt_x                                       // Otherwise print x as normally (negative)
                    add  x0, x0, :lo12:fmt_x
                    bl 	 printf                                          // Calling the print function to print the fmt_x string
                    b 	 temp_div                                        // Branch to temp_div label

print_space:        adrp x0, fmt_x2                                      // Add additional space to print statement
                    add  x0, x0, :lo12:fmt_x2    
                    bl 	 printf                                          // Calling the print function to print fmt_x2 string

temp_div:           adrp x10, temp_m                                     // Get address of variable temp
                    add  x10, x10, :lo12:temp_m
                    ldr  d0, [x10]                                       // Load temp into d0

                    scvtf d1, w19                                    // Convert value into a signed floating point number and store in d1
                    
                    adrp x10, divnum_m                                   // Get address of 100 (dividing number)
                    add  x10, x10, :lo12:divnum_m
                    ldr  d2, [x10]                                       // Load x10 into d2

                    fdiv d0, d1, d2                                      // temp = value/100

                    bl   arctan                                          // Call the arctan subroutine

                    adrp x0, fmt_arctan                                  // Setup print for arctan(x)
                    add  x0, x0, :lo12:fmt_arctan
                    bl   printf                                          // Calling the print function to print the fmt_arctan string

                    add  w19, w19, INCREMENT                     // value += INCREMENT

test:               cmp  w19, UPPER_MAX                              // Compare value and UPPER_MAX
                    b.le loop                                            // If value <= UPPER_MAX jump to loop label

exit:               adrp x0, fmt_end                                     // Setup print statement for file has ended
                    add  x0, x0, :lo12:fmt_end
                    bl   printf                                          // Calling the print function to print the fmt_end string

                    mov  w0, w20                                        // 1st arg (fd)
                    mov  x8, 57                                          // Close I/O request
                    svc  0                                               // Call system function

end:                ldp  fp, lr, [sp], dealloc                           // Deallocate memory for main
                    ret                                                	 // Return suboutine



    .balign 4                                                            // Align by 4 bits
    .global arctan                                                       // The pseudo op which sets the start label to "arctan" and makes sure that the "arctan" label is linked
arctan:
		    stp  fp, lr, [sp, -16]!                              // Memory allocation for subroutine
                    mov  fp, sp                                          // Set FP to SP

                    fmov d9, d0                                          // Move input from d0 into temorary register d9

                    adrp x10, stop 	                                 // Get address of the series ending condtional number
                    add  x10, x10, :lo12:stop
                    ldr  d10, [x10]                                      // Move stop limit into d10

                    adrp x10, zero_m                                     // Get address of variable holding 0
                    add  x0, x10, :lo12:zero_m
                    ldr  d15, [x10]                                      // Move 0 into d15 (arctan(x) sum)
                    ldr  d14, [x10]                                      // Move 0 into d15

                    mov  w11, 1                                          // initialize number of times run to 1 (incremented later)

                    fmov d12, 1.0                                        // n=d12 (initialized to 1, increments by 2 later)

arc_loop:
        	    cmp  w11, 1                                          // Compare counter to 1
                    b.gt arc_next1                                       // If greater than 1 then skip over initial step

                    fmov d13, d9                                         // Otherwise d13 = x
                    fmov d2, d13                                         // d2 = d13 (x before divided by n)
                    b    arc_contd

arc_next1:
		    fmov d13, d2                                         // reload value of x^n before it was divided by n                              
                    fmul d13, d13, d9                                    // mul current term by x
        	    fmul d13, d13, d9                                    // mul current term by x (x^n)
	
                    fneg d13, d13                                        // negate x (flips for adidition/subtraction in formula)
                    fmov d2, d13                                         // save value x^n before it is divided by n
                    fdiv d13, d13, d12                                   // current x^n/ n

arc_contd:
		    fadd d15, d15, d13                                   // arctan(x) holding total
                    add  w11, w11, 1                                     // Increment w11 by 1
                    fmov d1, 2.0                                         // Move 2.0 into d1
                    fadd d12, d12, d1                                    // increment n by 2

                    fcmp d13, d14                                        // Compare x^n/n with 0 to see if it is positive or negative
                    b.gt arc_check                                       // If positve, branch to arc_check

                    fneg d13, d13                                        // Otherwise is negative, negate it to turn positive
                    fcmp d13, d10                                        // Compare x^n/n with 1.0e-13
                    fneg d13, d13                                        // Negate the value back to get its original sign
                    b.gt arc_loop                                        // If x^n/n > 1.0e-13 branch back to loop to continue series
                    b 	 arc_exit                                        // Otherwise end series and break to arc_exit

arc_check:
		    fcmp d13, d10                                        // Compare x^n/n with 1.e-13
                    b.gt arc_loop                                        // If x^n/n > 1.0e-13 branch back to loop to continue series

arc_exit:									
		    fmov d0, d15                                         // Move arct(x) to d0 to return
	
                    ldp	 fp, lr, [sp], 16                                // Deallocate memory from stack
                    ret                                                  // Return subroutine

