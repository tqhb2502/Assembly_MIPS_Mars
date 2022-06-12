# lab 5, assignment 2
.data
	message1:	.asciiz "The sum of "
	message2:	.asciiz " and "
	message3:	.asciiz " is "
.text
	addi $s0, $zero, 11				# s0 = 2
	addi $s1, $zero, 13				# s1 = 5
	
	add $t0, $s0, $s1				# t0 = s0 + s1
	
	li $v0, 4					# print "The sum of "
	la $a0, message1
	syscall
	li $v0, 1					# print the value of s0
	add $a0, $zero, $s0
	syscall
	li $v0, 4					# print " and "
	la $a0, message2
	syscall
	li $v0, 1					# print the value of s1
	add $a0, $zero, $s1
	syscall
	li $v0, 4					# print " is "
	la $a0, message3
	syscall
	li $v0, 1					# print the result
	add $a0, $zero, $t0
	syscall