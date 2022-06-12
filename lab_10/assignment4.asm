.eqv	KEY_CODE	0xffff0004
.eqv	KEY_READY	0xffff0000

.eqv	DISPLAY_CODE	0xffff000c
.eqv	DISPLAY_READY	0xffff0008

.data
exit_command:	.asciiz "exit"
receive:	.space 16
new_line:	.byte '\n'

#---------------------------------------------------
# Main procedure
#---------------------------------------------------
.text
main:
	li $k0, KEY_CODE
	li $k1, KEY_READY
	
	li $s0, DISPLAY_CODE
	li $s1, DISPLAY_READY
	
	addi $s4, $zero, 4			# limit = $s4 = 4
	la $s3, receive				# $s3 = base address of receive
	
	la $t1, new_line
	lb $t7, 0($t1)				# load '\n' character to $t7
set:
	add $s2, $zero, $zero			# count = $s2 = 0
loop:
	seq $t8, $s2, $s4			# if count == limit then $t8 = 1 else $t8 = 0
	beq $t8, $zero, wait_for_key		# if count != limit, jump to wait_for_key
	jal check_command			# else call check_command procedure
	bne $a0, $zero, quit			# if $a0 != 0 then quit
wait_for_key:
	lw $t1, 0($k1)				# $t1 = KEY_READY
	beq $t1, $zero, wait_for_key		# if KEY_READY == 0 then continue waiting
read_key:					# else read key
	lw $t0, 0($k0)				# $t0 = KEY_CODE
	add $t2, $s2, $s3			# address = imm + base
	sb $t0, 0($t2)				# store character to receive string
	addi $s2, $s2, 1			# count = count + 1
wait_for_display:
	lw $t2, 0($s1)				# $t2 = DISPLAY_READY
	beq $t2, $zero, wait_for_display	# if DISPLAY_READY == 0 then continue waiting
						# else
#encrypt:					# change input key
#	addi $t0, $t0, 1
show_key:					# show key
	sw $t0, 0($s0)
check_new_line:
	beq $t0, $t7, set
continue:					# continue the loop
	j loop
quit:
	li $v0, 10
	syscall
end_main:
	
#---------------------------------------------------
# Procedure: check_command
# param[in]:	$s3, base address of receive string
# param[out]:	$a0, 0: continue, 1: exit
#---------------------------------------------------
check_command:
	add $a0, $zero, $zero			# $a0 = 0
	la $t0, exit_command			# $t0 = base address of exit_command
	addi $t1, $zero, 3			# index = $t1 = 3
check:
	bltz $t1, assign			# if index < 0 then assign
get_char_from_receive:
	add $t3, $t1, $s3			# address = imm + receive_base
	lb $t8, 0($t3)				# $t8 = receive[index]
get_char_from_exit_command:
	add $t3, $t1, $t0			# address = imm + exit_command_base
	lb $t9, 0($t3)				# $t9 = exit_command[index]
compare:
	bne $t8, $t9, done			# if receive[index] != exit_command[index] then assign $a0 = 1
	
	addi $t1, $t1, -1			# index = index - 1
	j check					# continue checking
assign:
	addi $a0, $zero, 1			# $a0 = 1
done:
	jr $ra
end_check_command:
