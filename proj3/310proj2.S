.global _start
.data
userinput: .ascii "Enter the filename:" # 20 bytes
filename: .space 256  # 16 bytes
buffer: .space 6

.text
_start:
    li a0, 1 # This portion before inputs message
    la a1, userinput
    addi a2, a0, 20
    li a7, 64
    ecall

    li a0, 0
    addi a1, a1, 20
    li a2, 256
    li a7, 63
    ecall

    li s3, 0x0A # Stores "\n" for cleanup filename
    j cleanup_filename # This is too mend-loop #

cleanup_filename: # This portion makes each input clean
    lb t0, 0(a1)
    beq t0, s3, replace_character
    addi a1, a1, 1
    j cleanup_filename

replace_character: # This portion replaces new filename bytes
    li t0, 0
    sb t0, 0(a1)
    j load_file

load_file: # This portion loads the content file 
    la a0, userinput
    addi a0, a0, 20
    li a1, 0
    li a2, 1024
    li a7, 1024
    ecall

    la a1, userinput
    addi a1, a1, 282
    li a2, 1000

    # Registers below are vari assignments looping
    li s2, 9 # max number of "\n" lines
    li s4, 0 # A condition like ending here up instr
    li s5, 0 # Sum of ints 
    li s6, 10 # Variable for base10 vals 
    j begin_line # This is setup to use

decrement: # Decrements s2 to show how reads passed
    addi s2, s2, -1
    j mend_loop

begin_line: # This portion is the starting file bytes reading; jump label! 
    li t0, 0 # counter file bytes
    beqz s4, countBytes # Since
    beqz s2, print_int # When s2 resets

countBytes: # This portion the starting-byte point in buffer resets s1-pointer iteratively 
    lb t1, 0(a1)
    beqz t1, starting_int # The jumps break converted ASCII side tests files end runs-loop bytes-needed bytes
        beq t1, s3, increment # If '\n' is found, increment counter
    addi a1, a1, 1 # Move to the next byte
    j countBytes

increment: # Increments s4
    addi s4, s4, 1
    j countBytes

starting_int: # Moves the pointer back to the beginning
    sub a1, a1, s4
    j exponent_loop1

exponent_loop1: # This loop is used for base10 exponentiation
    li t2, 1 # Initialize exponent
    addi t0, t0, -1 # Decrements the loop counter
    beqz t0, exponent_loop3
    j exponent_loop2

exponent_loop2: # This loop gets 10^n
    mul t2, t2, s6
    bnez t0, exponent_loop1
    j exponent_loop3

exponent_loop3: # This portion multiplies values for integer conversion
    li t4, 0 # Number that stores final output
    li t5, 0 # Temporary variable for digits
    lb t4, 0(a1) # Load byte at a1
    addi t4, t4, -48 # Reduce ASCII value to digit
    mul t5, t4, t2 # Multiply digit with its place value
    add s5, s5, t5 # Add to the sum
    addi a1, a1, 1 # Move to next byte
    addi s2, s2, -1 # Decrement counter
    bnez s2, exponent_loop1
    j end_loop

end_loop: # End of loop and sets up output
    addi a1, a1, 1
    li a0, 1
    li a7, 64
    ecall

print_int: # This portion sets up the integer for output
    la a1, userinput
    addi a1, a1, 281 # Moves pointer to storage area
    sb s3, 0(a1) # Stores "\n"
    j convert_ascii

convert_ascii: # Converts integer to ASCII and prints it
    li a0, 1
    addi a2, s5, 0
    li a7, 64
    ecall

exit: # Exit program
    li a0, 0
    li a7, 93
    ecall
