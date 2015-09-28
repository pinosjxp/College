# COURSE:     CSC 201
# ASSIGNMENT: 3
# STUDENT:    Joshua Pinos
# INSTRUCTOR: Dr. V. Dwight House
# DATE DUE:   Sunday, November 16, 2014, by noon
# PURPOSE:    To read entries of a square confusion matrix and find the number of matches and errors.
# INPUT:      A file of integers, one per line, terminated by zero. The first number will be
#             positive. Input is from stdin (standard input).
# OUTPUT:     The output is a message giving the number of matches and errors.
#             sum. Output is to stdout (standard output).

         .data
         .align 2
prompt1: .asciiz "\n\nThis program reads a list of integers into a matrix,"
prompt2: .asciiz "\nand then checks for confusion in machine learning."
prompt3: .asciiz "\n\nEnter the size of matrix (zero to quit): "
answer1: .asciiz "\nThe number of matches is: "
answer2: .asciiz "\nThe number of errors is: "
         .text
         .globl main
main:    
# print the prompt messages      See appendix B of P&H or chapter 4 of Britton
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt1     # $a0 = address of first prompt
         syscall               # print first prompt
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt2     # $a0 = address of second prompt
         syscall               # print second prompt

# Main program - calls read and sum functions
mloop:   li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt3     # $a0 = address of third prompt
         syscall               # print third prompt

         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read an integer - n
         move $a1, $v0         # $a1 = size of matrix
         beq  $v0, $zero, done # exit program

         li   $a0, 0x10000000  # $a0 = base address of matrix = 10000000 (hex)
         jal  reada            # read numbers into array - no prompts
         jal  process          # find number of matches and errors
         move $s0, $v0         # save return value

# Print the the results
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer1     # $a0 = address of first answer
         syscall               # print "The number of matches is: "

         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $s0         # $a0 = number of matches
         syscall               # print number of matches

         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer2     # $a0 = address of second answer
         syscall               # print "The number of errors is: "

         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $v1         # $a0 = number of errors
         syscall               # print number of errors

         b    mloop            # go back up and get another matrix

# Call system exit
done:    li   $v0, 10          # $v0 = exit system call code
         syscall               # halt program execution
# end of Main program ------------------------------------------------------

# Algorithm for reading numbers into a "matrix" (actually a one dim-array)
reada:   move $t0, $a0         # $t0 = base address of matrix
         mul  $t1, $a1, $a1    # $t2 = total number of elements in matrix (n*n)
         sll  $t1, $t1, 2      # $t1 = 4*n*n
         add  $t1, $t1, $t0    # $t1 = address at end matrix (or array)
loop:    beq  $t1, $t0, out    # if all numbers have been read exit routine
         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read an integer
         sw   $v0, 0($t0)      # store number just read into array
         addi $t0, $t0, 4      # increment address by 4
         b    loop             # branch back and test before reading next number
out:     jr   $ra              # return to main routine
# end of read routine ------------------------------------------------------

# Algorithm for finding the row sums

# match = error = 0
# for i = 0 .. n-1
#   for i = 1 .. n-1
#     if (i == j)
#       match = match + a[i,j]
#     else
#       error = error + a[i,j]
#     endif
#   end for j
# end for i
# return match, error

# Register usage
# $a0 = base address of array (matrix), a
# $a1 = n, size of matrix (number of rows and columns)
# $v0 = match
# $v1 = error
# $t0 = i
# $t1 = j
# $t2 = a[i,j]
# $t3 = address of a[i,j]

process:  and $v0,$v0,$0		 # Set match to zero
          and $v1,$v1,$0		 # Set error to zero
          and $t0,$t0,$0		 # Set i to zero
          and $t1,$t1,$0		 # Set j to zero
          
row:	  beq $t0,$a1,endo	         # if i = n, exit row loop
          and $t1,$t1,$0 	         # Set j to zero when array moves to next row
          
column:	  beq $t1,$a1,endi	         # if j = n, exit column loop
          sll $t4,$t0,2		         # $t4 = i * 4
          sll $t5,$t1,2		         # $t5 = j * 4
          mul $t4,$t4,$a1	         # $t4 = $t4 * n
          add $t3,$t4,$t5	         # $t3 = arbitrary address [i,j]
          add $t3,$t3,$a0	         # $t3 = address of a[i,j]
          lw  $t2,($t3)		         # $t2 = a[i,j] 
          bne $t0,$t1,else	         # if i = j: 
          add $v0,$v0,$t2	         # Add a[i,j] to match
          addi $t1,$t1,1		 # j = j + 1
          b endi			 # Break out of if statement
          
else:	  add $v1,$v1,$t2	         # if i != j: Add a[i,j] to error
          addi $t1,$t1,1		 # j = j + 1
          
endi:	  bne $t1,$a1,column             # Repeat column loop if j < n
          addi $t0,$t0,1		 # i = i + 1
          
endo:	  bne $t0,$a1,row	         # Repeat row loop if i < n
          jr $ra			 # Return to parent process
