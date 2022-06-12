#lab 3, assignment 5c

.data						# variables
	i:	.word				# variable i, word type, no init value
	n:	.word				# variable n, word type, no init value
	step:	.word				# variable step, word type, no init value
	sum:	.word				# variable sum, word type, no init value
	A:	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10				# A[0] of array A, n elements

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
	addi $s1, $zero, 10			# n = 10
	addi $s2, $zero, 1			# step = 1
	
loop:						# condition sum >= 0
	slt $t5, $s3, $zero			# $t5 = sum < 0 ? 1 : 0
	beq $t5, $zero, endloop			# sum >= 0 -> branch to endloop
	add $t6, $s0, $s0			# $t6 = 2 * i
	add $t6, $t6, $t6			# $t6 = 4 * i
	add $t7, $t6, $t4			# $t7 store the address of A[i]
	lw $t0, 0($t7)				# $t0 = A[i]
	add $s3, $s3, $t0			# sum = sum + A[i]
	add $s0, $s0, $s2			# i = i + step
	j loop					# jump to loop	
endloop:
