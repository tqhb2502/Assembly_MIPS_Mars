# lab 4, assignment 3d

.text									# instructions
	li $s1, 9							# load value for $s1
	li $s2, 8							# load value for $s2
	
	slt $t0, $s2, $s1						# $t0 = $s2 < $s1 ? 1 : 0
	beq $t0, $zero, label						# branch to label if $s2 >= $s1
	j exit								# if $s2 < $s1, exit
label:
	li $t1, 1
exit: