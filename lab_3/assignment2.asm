#lab 3, assignment 2

.data						# variables
	i:	.word				# variable i, word type, no init value
	n:	.word				# variable n, word type, no init value
	step:	.word				# variable step, word type, no init value
	sum:	.word				# variable sum, word type, no init value
	A:	.word				# A[0] of array A, n elements

.text						# instructions
# load variables to registers
	la $t0, i				# load address of variable i to $t0
	la $t1, n				# load address of variable n to $t1
	la $t2, step				# load address of variable step to $t2
	la $t3, sum				# load address of variable sum to $t3
	la $t4, A				# load address of A[0] to $t4
	
	lw $s0, 0($t0)				# $s0 = i
	lw $s1, 0($t1)				# $s1 = n
	lw $s2, 0($t2)				# $s2 = step
	lw $s3, 0($t3)				# $s3 = sum

# loop	
	add $s0, $zero, $zero			# i = 0
	add $s3, $zero, $zero			# sum = 0
	addi $s1, $zero, 3			# n = 3
	addi $s2, $zero, 1			# step = 1
	
	addi $t0, $zero, 2			# $t0 = 2
	sw $t0, 0($t4)				# A[0] = 2
	
	addi $t0, $zero, 5			# $t0 = 5
	sw $t0, 4($t4)				# A[1] = 5
	
	addi $t0, $zero, 3			# $t0 = 3
	sw $t0, 8($t4)				# A[2] = 3
loop:
	slt $t5, $s0, $s1			# $t5 = i < n ? 1 : 0
	beq $t5, $zero, endloop			# i == n -> branch to endloop
	add $t6, $s0, $s0			# $t6 = 2 * i
	add $t6, $t6, $t6			# $t6 = 4 * i
	add $t7, $t6, $t4			# $t7 store the address of A[i]
	lw $t0, 0($t7)				# $t0 = A[i]
	add $s3, $s3, $t0			# sum = sum + A[i]
	add $s0, $s0, $s2			# i = i + step
	j loop					# jump to loop	
endloop:
