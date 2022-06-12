#lab 3 assignment 3

.data							# variables
	test:	.word 4					# variable test, word type, init value
	a:	.word 2					# variable a, word type, init value 2
	b:	.word 5					# variable b, word type, init value 5		
				
.text							# constructions
	la $t1, a					# load address of variable a to $t1
	la $t2, b					# load address of variable b to $t2
	lw $s1, 0($t1)					# $s1 = a
	lw $s2, 0($t2)					# $s2 = b

	la $t0, test					# load address of variable test to $t0
	lw $s0, 0($t0)					# $s0 = test
	li $t1, 1					# $t1 = 1
	li $t2, 2					# $t2 = 2
	li $t3, 3					# $t3 = 3
	beq $s0, $t1, case_1				# test == 1 -> case_1
	beq $s0, $t2, case_2				# test == 2 -> case_2
	beq $s0, $t3, case_3				# test == 3 -> case_3
	j default					# default case
case_1:
	addi $s1, $s1, 1				# a = a + 1
	j continue					# jump to continue
case_2:
	addi $s1, $s1, -1				# a = a - 1
	j continue					# jump to continue
case_3:
	add $s2, $s2, $s2				# b = 2 * b
	j continue					# jump to continue
default:

continue:
	