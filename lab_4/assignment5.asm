# lab 4, assignment 5

.text							# instructions
	addi $s0, $zero, 3				# set value for $s0
	addi $s1, $zero, 10				# set value for $s1
	sllv $s2, $s1, $s0				# $s2 = $s1 * 2^($s0)
