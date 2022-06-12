# lab 5, assignment 3
.data
	x:	.space 32				# destination string x, empty
	y:	.space 32				# source string y
.text
	li $v0, 8					# read string y from standard input
	la $a0, y
	li $a1, 32
	syscall

strcpy:
	add $s0, $zero, $zero				# s0 = i = 0
	la $a1, y					# a1 = base address of y
	la $a2, x					# a2 = base address of x
L1:
	add $t1, $a1, $s0				# t1 = base address of y + i = address of y[i]
	lb $t2, 0($t1)					# t2 = y[i]
	
	add $t3, $a2, $s0				# t3 = base address of x + i = address of x[i]
	sb $t2, 0($t3)					# store y[i] to address of x[i]
	
	beq $t2, $zero, end_of_strcpy			# if y[i] == 0, exit
	
	addi $s0, $s0, 1				# i = i + 1
	j L1						# deal with next character
end_of_strcpy: