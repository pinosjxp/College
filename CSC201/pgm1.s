# COURSE:     CSC201
# ASSIGNMENT: 1
# STUDENT:    Joshua Pinos
# INSTRUCTOR: Dr. V. Dwight House
# DATE DUE:   Friday, September 19, 2014, by midnight
# PURPOSE:    To read non-negative 4-digit integers from stdin and find how long it takes to reach 6174.
# INPUT:      A file of positive 4-digit integers, one per line, terminated by an integer < 1000.
#             Input is from stdin (standard input).
# OUTPUT:     The number of iterations needed for the integer read to reach 6174 using the algorithm
#             described below. Output is to stdout (standard output).
#	      Example Output:
#		==============================================================
#		This program reads 4-digit integers from 
#		the keyboard and finds how long it takes to reach 6174. 
#		Enter a 4-digit integer (< 1000 to quit): 
#		It takes 4185 this many iterations to reach 6174: 3 
#		Enter a 4-digit integer (< 1000 to quit): 
#		It takes 9831 this many iterations to reach 6174: 7 
#		Enter a 4-digit integer (< 1000 to quit): 
#		It takes 2111 this many iterations to reach 6174: 5 
#		Enter a 4-digit integer (< 1000 to quit): 
#		It takes 1234 this many iterations to reach 6174: 3 
#		Enter a 4-digit integer (< 1000 to quit): 
#		It takes 6174 this many iterations to reach 6174: 0 
#		Enter a 4-digit integer (< 1000 to quit):
#		===============================================================
# Register usage:
#   $a0 = a number - a nonnegative integer (negative to signal quit)
#   $v0 = the value of the function

         .data
         .align 2
head1:   .asciiz "\n\nThis program reads 4-digit integers from"
head2:   .asciiz "\nthe keyboard and finds how long it takes to reach 6174." 
prompt:  .asciiz "\nEnter a 4-digit integer (< 1000 to quit): "
answer1: .asciiz "It takes "
answer2: .asciiz " this many iterations to reach 6174: "
newline: .asciiz "\n"
         .text
         .globl main
main:    
# print the prompt messages      See 4.6.1 on page 65 of Ellard's MIPS Tutorial
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
         la   $a0, prompt      # $a0 = address of prompt
         syscall               # print prompt
# read a number
         li   $t0, 1000        # for comparison with input
         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read integer, n
         blt  $v0, $t0, exit   # exit procedure and return to caller
         move $t0, $v0         # save n for function call and printing
# print first three parts of output line
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer1     # $a0 = address of string - "t(" 
         syscall               # print above string
# print number just read from input
         move $a0, $t0         # put n $a0 for printing
         li   $v0, 1           # $v0 = print_int system call code
         syscall               # print value of function
# print ) =
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer2     # $a0 = address of string - ") = "
         syscall               # print above string
# call function
         move $a0, $t0         # put n $a0 for function call
         addi $sp, $sp -4      # push AR onto stack
         sw   $ra, 0($sp)      # save return address on stack
         jal  process          # call function process
         lw   $ra, 0($sp)      # restore return address from stack
         addi $sp, $sp 4       # pop AR from stack
# print value of t(n)
         move $a0, $v0         # save result of the function call in $a0
         li   $v0, 1           # $v0 = print_int system call code
         syscall               # print value of function
         b    loop             # go back up and read another integer
exit:    jr   $ra              # return to calling routine

# ---------------------------------------------------------------
# Algorithm (pseudocode) for GetMaxMin
# input - 4 digits from process in $a0 - $a3

# put digits into array - D
# sort array using insertion sort
# for i = 1 to 3 do
#   j = i
#   value = D[i]
#   while (j > 0 and value < D[j-i]) do
#     D[j] = D[j-1]
#     j = j - 1
#   end while
#   D[j] = value
# end for
# max = getMax(D)
# min = getMin(D)
# return max, min

# Register Usage
# $a0 - n, the argument and also d0, the thousand's digit
# $a1 - d1, the hundred's digit
# $a2 - d2, the ten's digit
# $a3 - d3, the one's digit
# $v0 - max (return value from call to GetMaxMin) and
#       also count (return value to call from loop) 
# $v1 - min (return value from call to GetMaxMin)
# $t0 - i
# $t1 - j
# $t2 - 4 times an index
# $t3 - address of array elements
# $t4 - D[i] (value)
# $t5 - D[j-1]

getMaxMin:
         addi $sp, $sp, -4     # 
	 sw   $s0, 0($sp)      # 
         li   $s0, 0x10000000  # 
	 sw   $a0, 0($s0)      # store thousand's digit in D[0]
	 sw   $a1, 4($s0)      # store hundred's digit in D[1]
	 sw   $a2, 8($s0)      # store ten's digit in D[2]
	 sw   $a3, 12($s0)     # store one's digit in D[3]
         li   $t0, 1           # i = 1
for:     beq  $t0, 4, endfor   # test (i < 4) at top of for loop
         move $t1, $t0         # j = i
	 sll  $t2, $t0, 2      # $t2 = 4*i
	 add  $t3, $s0, $t2    # $t3 = address of D[i]
         lw   $t4, 0($t3)      # $t4 = D[i]
while:   beqz $t1, endw        # end while loop if j == 0
	 sll  $t2, $t1, 2      # $t2 = 4*j
	 add  $t3, $s0, $t2    # $t3 = address of D[j]
	 addi $t3, $t3, -4     # $t3 = address of D[j-1]
         lw   $t5, 0($t3)      # $t5 = D[j-1]		 
         bge  $t4, $t5, endw   # end while loop if D[i] >= D[j-1]
	 sw   $t5, 4($t3)      # D[j] = D[j-1]
	 addi $t1, $t1, -1     # j = j - 1	 
	 b    while            # 
endw:    sll  $t2, $t1, 2      # 
         add  $t3, $t2, $s0    # 
         sw   $t4, 0($t3)      # D[j] + D[i]
	 addi $t0, $t0, 1      # i = i + 1 part of for loop
	 b    for              # go back to top of for loop
endfor:  lw   $a0, 0($s0)      # 
         lw   $a1, 4($s0)      # 		 
         lw   $a2, 8($s0)      # 	
         lw   $a3, 12($s0)     # 		 
         addi $sp, $sp, -4     # 
         sw   $ra, 0($sp)      # 
         jal  getMin	       # 
         move $v1, $v0         # 		 
         jal  getMax	       # 		 
         lw   $ra, 0($sp)      # 
	 lw   $s0, 4($sp)      # 		 
         addi $sp, $sp, 8      # handle both $ra and $s0 at once
         jr $ra                # return to caller - process
 
# ---------------------------------------------------------------
# Algorithm (pseudocode) for getMax
# intput - parameters a, b, c, d from GetMaxMin
# return a + 10*b + 100*c + 1000*d

# Register Usage
# $a0 - a
# $a1 - b
# $a2 - c
# $a3 - d
# $v0 - max (return value)
# $t0 - 10
# $t1 - 100 and 1000
# $t2 - terms from above expression

getMax:
         li   $t0, 10          # save constant 10 for multiplication
         move $v0, $a0         # $v0 = a
         mul  $t1, $t0, $a1    # $t1 = 10*b
         add  $v0, $v0, $t1    # $v0 = a + 10*b
         mul  $t2, $t0, $t0    # $t2 = 100
         mul  $t1, $t2, $a2    # $t1 = 100*c
         add  $v0, $v0, $t1    # $v0 = a + 10*b + 100*c
         mul  $t2, $t2, $t0    # $t2 = 1000
         mul  $t1, $t2, $a3    # $t1 = 1000*d
         add  $v0, $v0, $t1    # $v0 = a + 10*b + 100*c + 1000*d
         jr   $ra              # return to caller

# ---------------------------------------------------------------
# Algorithm (pseudocode) for getMin
# intput - parameters a, b, c, d from GetMaxMin
# return 1000*a + 100*b + 10*c + d

# Register Usage
# $a0 - a
# $a1 - b
# $a2 - c
# $a3 - d
# $v0 - min (return value)
# $t0 - 10
# $t1 - 100 and 1000
# $t2 - terms from above expression

getMin:
         li   $t0, 10          # save constant 10 for multiplication
         move $v0, $a3         # $v0 = d
         mul  $t1, $t0, $a2    # $t1 = 10*c
         add  $v0, $v0, $t1    # $v0 = d + 10*c
         mul  $t2, $t0, $t0    # $t2 = 100
         mul  $t1, $t2, $a1    # $t1 = 100*b
         add  $v0, $v0, $t1    # $v0 = d + 10*c + 100*b
         mul  $t2, $t2, $t0    # $t2 = 1000
         mul  $t1, $t2, $a0    # $t1 = 1000*a
         add  $v0, $v0, $t1    # $v0 = d + 10*c + 100*b + 1000*a
         jr   $ra              # return to caller

# ---------------------------------------------------------------
# Algorithm (pseudocode) for process
# intput - parameter n from main

# current = n
# count = 0
# while (current != 6174) do
#   d0 = current/1000           thousand's digit
#   d1 = (current/100) mod 10   hundred's digit
#   d2 = (current/10) mod 10    ten's digit
#   d3 = current mod 10         one's digit
#   call GetMaxMin (d0, d1, d2, d3)
#   current = max - min
#   count = count + 1
# end while
# return count

# Register Usage
# $a0 - n, the argument and also d0
# $a1 - d1
# $a2 - d2
# $a3 - d3
# $v0 - max (return value from call to GetMaxMin) and
#       also count (return value to call from loop) 
# $v1 - min (return value from call to GetMaxMin)
# $t0 - current
# $t1 - count (return value)
# $t2 - constant - 6174
# $t3 - constant - 10

process: move $t0,$a0           	#Sets current to n
         li $t1, 0			#Set count to 0
while1:	 li $t2, 6174			#Sets $t2 to 6174
         li $t3, 10			#Sets $t3 to 10
         beq $t0, $t2, finish		#While current dne 6174, do code below		
         div $a0, $t0, $t3		#d0=Current/10
         div $a0, $a0, $t3		#d0=Current/100
         div $a0, $a0, $t3		#d0=Current/1000
         div $a1, $t0, $t3		#d1=current/10
         div $a1, $a1, $t3		#d1=current/100
         div $a1, $a1, $t3		#d1=current/1000
         mfhi $a1			#Store mod 10 result in d1
         div $a2, $t0, $t3		#d2=current/10
         div $a2, $a2, $t3		#d2=current/100
         mfhi $a2			#Store mod 10 resutl in d2
         div $a3, $t0, $t3		#d3=current/10
         mfhi $a3			#Store mod 10 result in d3
         addi $sp,$sp, -8		#Allocated memory on stack for return address and count
         sw $ra,0($sp)			#Save return address to stack
         sw $t1,4($sp)			#Save count to stack
         jal getMaxMin			#Calls getMaxMin function
         lw $ra, 0($sp)			#Recovers return address from stack
         lw $t1, 4($sp)			#Recovers count frm stack
         addi $sp,$sp, 8		#Deallocate memory from stack
         sub $t0, $v0, $v1		#Set current=max-min
         addi $t1, $t1, 1		#Count=count+1
         j while1			#Repeat while1 
finish:	 move $v0, $t1			#Places count in $v0(Return register)
         jr $ra				#Return to loop
