# CMPE 310 Assembly Project 2

## Project Description
Write a RISC-V assembly program that performs the following functions:
1. Reads a set of integers from a file into a memory array. The data file name is to be read from the command line. You are welcome to use the provided code examples and macros to complete this project.
2. **Format of the data file**:
   - The first line contains the number of data points.
   - Each subsequent line contains one integer value.
   - The maximum number of integers in the file is **1000**.
3. Add all the integers read from the file and print out the sum on the screen.

## Submission Instructions
- Use Blackboard to submit your code.
- Turn in a single-file PDF report with your submission.

## Requirements
- Make your code modular:
  - Create subroutines for:
    - Opening the file
    - Reading integers and populating the array
    - Performing calculations
    - Printing the output
- Use the C library functions where applicable:
  - Relevant functions: `fopen`, `fscanf`, `printf`.

## Notes
- You can construct your own data files for testing, ensuring they follow the specified format.
- Your code will be tested with additional examples.

