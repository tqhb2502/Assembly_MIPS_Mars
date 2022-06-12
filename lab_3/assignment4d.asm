#lab 3, assignment 4d

.data					# variables
	i:	.word 5			# variable i, word type, init value 2
	j:	.word 2			# variable j, word type, init value 5
	x:	.word 0			# variable x, word type, init value 0
	y:	.word 2			# variable y, word type, init value 2
	z:	.word 1			# variable z, word type, init value 1
	m:	.word 8			# variable m, word type, init value 8
	n:	.word 9			# variable n, word type, init value 9

.text					# instructions
# load variables to registers
	la $t8, i			# load address of variable i to $t8
	la $t9, j			# load address of variable j to $t9
	lw $s1, 0($t8)			# $s1 = i
	lw $s2, 0($t9)			# $s2 = j
	
	la $t8, x			# load address of variable x to $t8
	la $t9, y			# load address of variable y to $t9
	lw $s4, 0($t8)			# $s4 = x
	lw $s5, 0($t9)			# $s5 = y
	
	la $t8, z			# load address of variable z to $t8
	lw $s6, 0($t8)			# $s6 = z
	
	la $t8, m			# load address of variable m to $t8
	la $t9, n			# load address of variable n to $t9
	lw $s0, 0($t8)			# $s0 = m
	lw $s3, 0($t9)			# $s3 = n
	
start:					# if i + j > m + n
	add $t0, $s1, $s2		# $t0 = i + j
	add $t1, $s0, $s3		# $t1 = m + n
	slt $t2, $t1, $t0		# $t2 = (m + n) < (i + j) ? 1 : 0
	beq $t2, $zero, else		# branch if (m + n) >= (i + j), otherwise, continue
	addi $s4, $s4, 1		# x = x + 1
	addi $s6, $zero, 1		# z = 1
	j endif				# jump to endif, skip "else" part
	
else:
	addi $s5, $s5, -1		# y = y - 1
	add $s6, $s6, $s6		# z = 2 * z
endif:
