# lab 7 assignment 3

.text
prepare:
	li $s0, 25
	li $s1, 13
push:
	addi $sp, $sp, -8			# adjust stack pointer
	sw $s0, 4($sp)				# push the value of s0 to stack
	sw $s1, 0($sp)				# push the value of s1 to stack
pop:
	lw $s0, 0($sp)				# pop the top of stack to s0
	lw $s1, 4($sp)				# pop the top of stack to s1
	addi $sp, $sp, 8			# adjust stack pointer