#lab 3, assignment 1

.data					# variables
	i:	.word 5			# variable i, word type, init value 2
	j:	.word 2			# variable j, word type, init value 5
	x:	.word 0			# variable x, word type, init value 0
	y:	.word 2			# variable y, word type, init value 2
	z:	.word 1			# variable z, word type, init value 1

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
	
start:					# if i + j <= 0
	add $t0, $s1, $s2		# $t0 = i + j
	bgtz $t0, else			# branch if i + j > 0, otherwise, continue
	addi $s4, $s4, 1		# x = x + 1
	addi $s6, $zero, 1		# z = 1
	j endif				# jump to endif, skip "else" part
	
else:
	addi $s5, $s5, -1		# y = y - 1
	add $s6, $s6, $s6		# z = 2 * z
endif:
