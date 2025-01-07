    .global _start       # Provide program starting address to linker

    .data
    
prompt1: .asciiz "Enter first string (up to 255 characters): "
prompt2: .asciiz "Enter second string: "
distance_msg: .asciiz "Hamming distance: "
string1: .space 256          # Allocate space for first string
string2: .space 256          # Allocate space for second string
newline: .asciiz "\n"

    .text
_start:
    # Print the prompt for the first string
    li a0, 1           # file descriptor for stdout
    la a1, prompt1     # address of the prompt
    li a2, 31          # length of the prompt
    li a7, 64          # syscall: write
    ecall

    # Read the first string
    li a0, 0           # file descriptor for stdin
    la a1, string1     # buffer to store the string
    li a2, 255         # maximum characters to read
    li a7, 63          # syscall: read
    ecall

    # Null terminate the string manually if needed
    sb zero, (a1)      # Set zero byte at the end of the string

    # Print the prompt for the second string
    li a0, 1           # stdout
    la a1, prompt2     # address of the second prompt
    li a2, 32          # length of the prompt
    li a7, 64          # syscall: write
    ecall

    # Read the second string
    li a0, 0           # stdin
    la a1, string2     # buffer to store the string
    li a2, 255         # maximum characters to read
    li a7, 63          # syscall: read
    ecall

    # Null terminate the string manually if needed
    sb zero, (a1)      # Set zero byte at the end of the string

    # Calculate Hamming distance
    la t1, string1     # t1 points to string1
    la t2, string2     # t2 points to string2
    li t3, 0           # t3 is the Hamming distance counter

calculate:
    lbu t4, 0(t1)      # Load byte from string1
    lbu t5, 0(t2)      # Load byte from string2
    beqz t4, finish    # If end of string1, finish
    beqz t5, finish    # If end of string2, finish

    xor t6, t4, t5     # XOR the bytes
    li t7, 0x01        # Initial mask

count_bits:
    and t8, t6, t7     # Isolate bit
    bnez t8, increment # If bit is 1, increment distance
    slli t7, t7, 1     # Shift mask left
    bne t7, zero, count_bits # If mask is not zero, loop

increment:
    addi t3, t3, 1     # Increment Hamming distance

    addi t1, t1, 1     # Increment pointer t1
    addi t2, t2, 1     # Increment pointer t2
    j calculate        # Repeat

finish:
    # Output the Hamming distance
    li a0, 1           # stdout
    la a1, distance_msg
    li a2, 19          # length of the message
    li a7, 64          # syscall: write
    ecall

    mv a1, t3          # Move distance to a1
    li a0, 1           # stdout
    li a2, 1           # length (1 byte)
    li a7, 64          # syscall: write
    ecall

    # Exit
    li a0, 0           # Exit code
    li a7, 93          # syscall: exit
    ecall
