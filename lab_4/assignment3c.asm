# lab 4, assignment 3c

.text								# instructions
	li $s1, 0x11111111					# load value for $s1
	xori $s0, $s1, 0xffffffff				# $s0 = not($s1)