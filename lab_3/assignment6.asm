# lab 3 assignment 6

.data								# variables
	i:	.word 0						# variable i, word type, init value 0
	n:	.word 10					# variable n, word type, init value 10
	step:	.word 1						# variable n, word type, init value 1
	A:	.word -100, -2, 40, -36, 32, 25, 2, 8, 9, 37	# array of n integer elements
	max:	.word 0						# variable max, word type, init value 0
	
.text								# instructions
	la $t0, i						# load address of variable i to $t0
	la $t1, n						# load address of variable n to $t1
	la $t2, step						# load address of variable step to $t2
	la $t3, A						# load base address of array A to $t3
	la $t8, max						# load address of variable max to $t8
	
	lw $s0, 0($t0)						# $s0 = i
	lw $s1, 0($t1)						# $s1 = n
	lw $s2, 0($t2)						# $s2 = step
	lw $s4, 0($t8)						# $s4 = max

loop:
	slt $t0, $s0, $s1					# $t0 = i < n ? 1 : 0
	beq $t0, $zero, endloop					# end loop if i == n
	
	add $t1, $s0, $s0					# $t1 = 2 * i
	add $t1, $t1, $t1					# $t1 = 4 * i
	add $t4, $t1, $t3					# $t4 = address of A[i]
	lw $s3, 0($t4)						# $s3 = A[i]
	
	slt $t5, $s3, $zero					# $t5 = A[i] < 0 ? 1 : 0
if:
	beq $t5, $zero, endif					# if A[i] >= 0, branch to endif
	sub $s3, $zero, $s3					# $s3 = 0 - A[i]
endif:

	slt $t5, $s4, $s3					# $t5 = max < abs(A[i]) ? 1 : 0
if_2:
	beq $t5, $zero, endif_2					# if max >= abs(A[i]), branch to endif_2
	add $s4, $zero, $s3					# max = abs(A[i])
endif_2:

	add $s0, $s0, $s2					# i = i + step
	j loop							# jump back to loop
endloop:

	sw $s4, 0($t8)						# store the value of variable max back to its address