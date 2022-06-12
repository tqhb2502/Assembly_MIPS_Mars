# lab 4, assignment 3a

.text								# instructions
	li $s1, -2502						# load value for $s1
	bltz $s1, negative					# test if $s1 is negative
	# $s1 is positive
	j assign
negative:
	# $s1 is negative
	sub $s1, $zero, $s1					# $s1 = 0 - $s1
assign:
	add $s0, $zero, $s1					# $s0 = abs($s1)