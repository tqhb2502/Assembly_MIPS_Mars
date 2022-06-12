# lab 7 assignment 5

.text
main:
	li $s0, 2000				# load variables
	li $s1, -500
	li $s2, 1
	li $s3, 300
	li $s4, 0
	li $s5, -1
	li $s6, -111
	li $s7, 89
	
	addi $sp, $sp, -44			# adjust sp
	
	sw $s0, 40($sp)				# max value
	sw $zero, 36($sp)			# max value's position
	sw $s0, 32($sp)				# min value
	sw $zero, 28($sp)			# min value's position
	
	sw $s7, 24($sp)				# store variables to stack
	sw $s6, 20($sp)
	sw $s5, 16($sp)
	sw $s4, 12($sp)
	sw $s3, 8($sp)
	sw $s2, 4($sp)
	sw $s1, 0($sp)
	
	jal max_min				# call max_min procedure
	
	lw $t0, 40($sp)				# load result
	lw $t1, 36($sp)
	lw $t2, 32($sp)
	lw $t3, 28($sp)
	
	addi $sp, $sp, 44			# restore sp
	
quit:						# terminate
	li $v0, 10
	syscall
end_main:

#-------------------------------------------------------------------
# procedure max_min: find max value, min value and their positions in array
# param[in]: 7 value in stack [4-10]
# param[out]: 4 value in stack [0-3]
#-------------------------------------------------------------------
max_min:
	lw $t0, 40($sp)				# load max value to t0
	lw $t1, 36($sp)				# load max value postion to t1
	lw $t2, 32($sp)				# load min value to t2
	lw $t3, 28($sp)				# load min value postion to t3
	
	li $t4, 24				# t4 = offset
loop:
	bltz $t4, done				# if t4 < 0 then done
	
	add $t5, $t4, $sp			# t5 = address of current value
	lw $t6, 0($t5)				# t6 = current value
check_max:
	slt $t8, $t0, $t6			# if max value < current value then t8 = 1
	beq $t8, $zero, check_min		# if max value >= current value then no need to assign new max value
assign_max:
	add $t0, $zero, $t6			# max value = current value
	addi $t7, $t4, 4			# t7 = offset + 4
	srl $t1, $t7, 2				# get position
check_min:
	sgt $t8, $t2, $t6			# if min value > current value then t8 = 1
	beq $t8, $zero, next_value		# if min value <= current value then no need to assign new min value
assign_min:
	add $t2, $zero, $t6			# min value = current value
	addi $t7, $t4, 4			# t7 = offset + 4
	srl $t3, $t7, 2				# get position
next_value:
	addi $t4, $t4, -4			# offset = offset - 4
	j loop					# continue loop
done:
	sw $t0, 40($sp)				# store max value
	sw $t1, 36($sp)				# store max value position
	sw $t2, 32($sp)				# store min value
	sw $t3, 28($sp)				# store min value position
	jr $ra					# return to calling procedure






