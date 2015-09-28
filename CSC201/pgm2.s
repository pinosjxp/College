# COURSE:     CSC201
# ASSIGNMENT: 2
# STUDENT:    Joshua Pinos
# INSTRUCTOR: Dr. V. Dwight House
# DATE DUE:   Sunday, October 26, 2014, by noon
# PURPOSE:    To read pairs of positive integers from stdin and
 
# INPUT:      A file of positive integers, one per line, terminated by a negative integer.
#             Input is from stdin (standard input). (File has odd number of lines.)
# OUTPUT:     The output is the list of function values obtained from using input
#             pairs as function arguments.  Output is to stdout (standard output).

# Register usage:
#   $a0 = the first number - a positive integer (negative to signal quit)
#   $a1 = the second number - a positive integer
#   $v0 = the value of the function

         .data
         .align 2
head1:   .asciiz "\n\nThis program reads pairs of positive integers, n and k,"
head2:   .asciiz "\nfrom the keyboard and finds n choose k, C(n, k)\n" 
prompt1: .asciiz "\nEnter a nonnegative integer (negative to quit): "
prompt2: .asciiz "Enter another nonnegative integer no greater than the first: "
choose:  .asciiz " choose "
equals:  .asciiz " = "
newline: .asciiz "\n"
         .text
         .globl main
main:    
# print the prompt messages      See page appendix B of Patterson & Hennessy
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, head1       # $a0 = address of first heading
         syscall               # print first heading
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, head2       # $a0 = address of second heading
         syscall               # print second heading
# Main program - calls loop procedure
         jal  loop             # read numbers from keyboard and find remainders
# print new line
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, newline     # $a0 = address of newline
         syscall               # print newline character
# Call system exit
         li   $v0, 10          # $v0 = exit system call code
         syscall               # halt program execution

# ---------------------------------------------------------------
# Algorithm for looping and reading numbers from stdin (keyboard)
# prompt user for the first number number
loop:    li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt1     # $a0 = address of first prompt
         syscall               # print first prompt
# read the first number
         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read first integer, n
         blt  $v0, $zero, exit # exit procedure and return to caller
         move $t0, $v0         # save n for printing & function call
# prompt the user to enter second number
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt2     # $a0 = address of second prompt
         syscall               # print second prompt
# read the second number
         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read second integer, y
         move $t1, $v0         # save k for printing & function call
         move $a0, $t1         # put y in $a0 for function call
# print first number
         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $t0         # $a0 = n, the first number read
         syscall               # print n
# print " choose "
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, choose      # $a0 = address of the string " choose "
         syscall               # print " choose "
# print second number
         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $t1         # $a0 = k, the second number read
         syscall               # print n
# print " = "
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, equals      # $a0 = address of the string " = "
         syscall               # print " = "
# call function
         move $a0, $t0         # put n into $a0 for function call
         move $a1, $t1         # put k into $a1 for function call
         addi $sp, $sp -4      # push AR onto stack
         sw   $ra, 0($sp)      # save return address on stack
         jal  nchk             # call function f
         lw   $ra, 0($sp)      # restore return address from stack
         addi $sp, $sp 4       # pop AR from stack
         move $t1, $v0         # save result of the function call in $t1
# print answer
         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $t1         # $a0 = value of function
         syscall               # print value of function
# print new line
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, newline     # $a0 = address of newline
         syscall               # print newline character

         b    loop             # go back up and read another integer
exit:    jr   $ra              # return to calling routine

# ---------------------------------------------------------------
# Algorithm for finding C(n, k)

# C(n, k) = C(n - 1, k - 1) + C(n - 1, k)

# Register Usage
# $a0 - n, the first argument
# $a1 - k, the second argument
# $v0 - C(n, k) - the return value
# $t0 - constant 1 and return value from recursive call

nchk:   li   $t0, 0		# Sets $t0 to 0
	li   $v0, 0		# Sets $v0 to 0
	addi $sp, $sp,-4	# Makes space on stack for return address
	sw   $ra, 0($sp)	# Saves return address to stack
	jal  nchklp		# Jumps to main loop of algorithm
	lw   $ra, 0($sp)	# Loads return address form stack
	addi $sp, $sp, 4	# Realloactes space on stack 
	add  $v0, $v0, $t0	# C(n, k)=$t0 ///// The sum of all the recursive calls
	jr   $ra		# Return to calling routine
nchklp:	beq  $a1, $0, chkend    # If k == 0, jump to chkend
	beq  $a0, $a1, chkend   # If n == k, jump to chkend
	addi $sp, $sp, -12      # Makes space on stack for n, k, and return address
        sw   $ra, 0($sp)	# Saves return address from stack
        sw   $a0, 4($sp)	# Saves n to stack
        sw   $a1, 8($sp)	# Saves k to stack
        subi $a0, $a0, 1	# n = n - 1
        subi $a1, $a1, 1 	# k = k - 1
	jal  nchklp		# Recursive call to nchklp with n=n-1 and k=k-1 
	lw   $a1, 8($sp)	# Loads k from stack
	lw   $a0, 4($sp)	# Loads n from stack
	lw   $ra, 0($sp)	# Loads return address form stack
	addi $sp, $sp, 12	# Realloactes space on stack
	addi $sp, $sp, -12      # Makes space on stack again for n, k, and return address
        sw   $ra, 0($sp)	# Saves return address form stack
        sw   $a0, 4($sp)	# Saves n to stack
        sw   $a1, 8($sp)	# Saves k to stack
        subi $a0, $a0, 1 	# n = n - 1
	jal  nchklp		# Recursive call to nchklp with n = n - 1 and k
	lw   $a1, 8($sp)	# Loads k from stack
	lw   $a0, 4($sp)	# Loads n from stack
	lw   $ra, 0($sp)	# Loads return address from stack
	addi $sp, $sp, 12	# Reallocates space on stack
	jr   $ra		# Return to calling routine
chkend: addi $t0, $t0, 1	# $t0=$t0+1 ///// Sum of recursive calls
	jr   $ra		# Return to calling routine
