# lab 4, assignment 4

.text							# instructions
	li $s7, 0					# set overflow flag $s7 = 0
	addi $s0, $zero, 1000000000			# set value for $s0
	addi $s1, $zero, 1000000000			# set value for $s1
	
	xor $t0, $s0, $s1				# check if $s0 and $s1 have the same sign
	bltz $t0, exit					# if the 2 sign are different, overflow can't occur
	addu $s2, $s0, $s1				# $s2 = $s0 + $s1
	xor $t0, $s0, $s2				# check if the sum has the same sign as the 2 operands
	bltz $t0, overflow				# if the sum has different sign from the 2 operands, overflow has occured
	j exit						# otherwise, not overflow
overflow:
	li $s7, 1					# set overflow flag $s7 = 1
exit: