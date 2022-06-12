.eqv	MONITOR_SCREEN	0x10010000
.eqv	RED		0x00ff0000
.eqv	GREEN		0x0000ff00
.eqv	BLUE		0x000000ff
.eqv	WHITE		0x00ffffff
.eqv	YELLOW		0x00ffff00

.text
main:
prepare:
	li $k0, MONITOR_SCREEN			# load screen address
	addi $s0, $zero, 4			# count = $s0 = 4 (pair of rows)
	addi $a0, $zero, 0			# add_value = $a0 = 0
	li $a1, WHITE				# $a1 = white color
loop:
	beq $s0, $zero, exit			# if count == 0 then exit
	
	jal draw_odd_row
	addi $a0, $a0, 32			# add_value = add_value + 32
	
	jal draw_even_row
	addi $a0, $a0, 32			# add_value = add_value + 32

	addi $s0, $s0, -1			# count = count - 1
	j loop
exit:
	li $v0, 10
	syscall
end_main:

#------------------------------------------------------
# Draw odd row
# param[in]:	$k0, base address
#		$a0, add value
#		$a1, white color
#------------------------------------------------------
draw_odd_row:
	addi $t0, $zero, 3			# current = $t0 = 3
loop_2:
	bltz $t0, return_2

	sll $t1, $t0, 1				# index = current * 2
	sll $t1, $t1, 2				# imm = index * 4
	add $t1, $t1, $a0			# imm = imm + add_value
	add $t2, $t1, $k0			# address = imm + base
	sw $a1, 0($t2)
	
	addi $t0, $t0, -1			# current = current - 1
	j loop_2
return_2:
	jr $ra					# return to main
#------------------------------------------------------
# Draw even row
# param[in]:	$k0, base address
#		$a0, add value
#		$a1, white color
#------------------------------------------------------
draw_even_row:
	addi $t0, $zero, 3			# current = $t0 = 3
loop_1:
	bltz $t0, return_1

	sll $t1, $t0, 1				# index = current * 2
	addi $t1, $t1, 1			# index = index + 1
	sll $t1, $t1, 2				# imm = index * 4
	add $t1, $t1, $a0			# imm = imm + add_value
	add $t2, $t1, $k0			# address = imm + base
	sw $a1, 0($t2)
	
	addi $t0, $t0, -1			# current = current - 1
	j loop_1
return_1:
	jr $ra					# return to main