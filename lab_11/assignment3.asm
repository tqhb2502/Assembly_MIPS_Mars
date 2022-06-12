.eqv	IN_ADDRESS_HEXA_KEYBOARD 0xffff0012
.eqv	OUT_ADDRESS_HEXA_KEYBOARD 0xffff0014

.data
message:	.asciiz "Key scan code "

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:
	#---------------------------------------------------------
	# Enable interrupts you expect
	#---------------------------------------------------------
	# Enable the interrupt of Keyboard matrix 4x4 of Digital Lab Sim
	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x80					# bit 7 = 1, enable interrupt
	sb $t3, 0($t1)

	#---------------------------------------------------------
	# Loop an print sequence numbers
	#---------------------------------------------------------
	add $s0, $zero, $zero				# count = $s0 = 0
loop:
	addi $s0, $s0, 1				# count = count + 1
print_seq:						# print sequence
	addi $v0, $zero, 1
	add $a0, $zero, $s0
	syscall
print_eol:						# print end of line
	addi $v0, $zero, 11
	li $a0, '\n'
	syscall
sleep:							# sleep 300 ms
	addi $v0, $zero, 32
	addi $a0, $zero, 300
	syscall

	nop						# nop instruction is mandatory here
	b loop
end_main:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
	#-------------------------------------------------------
	# SAVE the current REG FILE to stack
	#-------------------------------------------------------
save:
	sw $ra, 0($sp)
	addi $sp, $sp, 4
	sw $at, 0($sp)
	addi $sp, $sp, 4
	sw $v0, 0($sp)
	addi $sp, $sp, 4
	sw $a0, 0($sp)
	addi $sp, $sp, 4
	sw $t1, 0($sp)
	addi $sp, $sp, 4
	sw $t3, 0($sp)
	addi $sp, $sp, 4
	#--------------------------------------------------------
	# Processing
	#--------------------------------------------------------
print_msg:
	addi $v0, $zero, 4
	la $a0, message
	syscall
get_code:
	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t2, OUT_ADDRESS_HEXA_KEYBOARD
	
	li $t3, 0x81					# row 1, re-enable bit 7
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bne $a0, $zero, print_code
	
	li $t3, 0x82					# row 2, re-enable bit 7
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bne $a0, $zero, print_code
	
	li $t3, 0x84					# row 3, re-enable bit 7
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bne $a0, $zero, print_code
	
	li $t3, 0x88					# row 4, re-enable bit 7
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
print_code:
	addi $v0, $zero, 34
	syscall
	li $v0, 11					# print end of line
	li $a0, '\n'
	syscall
	#--------------------------------------------------------
	# Evaluate the return address of main routine
	# epc <= epc + 4
	#--------------------------------------------------------
next_pc:
	mfc0 $at, $14
	addi $at, $at, 4
	mtc0 $at, $14
	#--------------------------------------------------------
	# RESTORE the REG FILE from STACK
	#--------------------------------------------------------
restore:
	addi $sp, $sp, -4
	lw $t3, 0($sp)
	addi $sp, $sp, -4
	lw $t1, 0($sp)
	addi $sp, $sp, -4
	lw $a0, 0($sp)
	addi $sp, $sp, -4
	lw $v0, 0($sp)
	addi $sp, $sp, -4
	lw $at, 0($sp)
	addi $sp, $sp, -4
	lw $ra, 0($sp)
return:
	eret						# return to main