# lab 4, assignment 1

.text								# instructions
	addi $s1, $zero, -2000000000				# set value for $s1
	addi $s2, $zero, -2000000000				# set value for $s2
start:
	li $t0, 0						# overflow flag $t0 = 0
	addu $s3, $s1, $s2					# $s3 = $s1 + $s2, unsigned, no overflow
	
	xor $t1, $s1, $s2					# test if $s1 and $s2 have the same sign
	bltz $t1, EXIT						# if the 2 signs are different, exit
	slt $t2, $s3, $s1					# compare $s3 with $s1
	bltz $s1, NEGATIVE					# test if $s1 and $s2 are negative
	# $s1 and $s2 are positive
	beq $t2, $zero, EXIT					# if $s3 >= $s1, not overflow
	j OVERFLOW						# otherwise, overflow has occured
NEGATIVE:
	# $s1 and $s2 are negative
	bne $t2, $zero, EXIT					# if $s3 < $s1, not overflow
	# otherwise, overflow has occured
OVERFLOW:
	li $t0, 1						# overflow flag $t0 = 1
EXIT:
