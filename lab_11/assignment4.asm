.eqv	IN_ADDRESS_HEXA_KEYBOARD	0xffff0012
.eqv	COUNTER				0xffff0013	# time counter

.eqv	MASK_CAUSE_COUNTER		0x00000400	# bit 10: counter interrupt
.eqv	MASK_CAUSE_KEYMATRIX		0x00000800	# bit 11: key matrix interrupt

.data
msg_keypress:	.asciiz "Someone has pressed a key!\n"
msg_counter:	.asciiz "Time inteval!\n"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:
	#---------------------------------------------------------
	# Enable interrupts you expect
	#---------------------------------------------------------
	
	# Enable the interrupt of Keyboard matrix 4x4 of Digital LabSim
	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x80
	sb $t3, 0($t1)
	
	# Enable the interrupt of TimeCounter of Digital Lab Sim
	li $t1, COUNTER
	sb $t1, 0($t1)
	
	#---------------------------------------------------------
	# Loop an print sequence numbers
	#---------------------------------------------------------
	add $s0, $zero, $zero			# count = $s0 = 0
loop:
	addi $s0, $s0, 1			# count = count + 1
print_seq:					# print sequence
	addi $v0, $zero, 1
	add $a0, $zero, $s0
	syscall
print_eol:					# print end of line
	addi $v0, $zero, 11
	li $a0, '\n'
	syscall
sleep:				# sleep 200 ms, BUG: must sleep to wait for time counter
	addi $v0, $zero, 32
	addi $a0, $zero, 200
	syscall

	nop					# nop instruction is mandatory here
	b loop
end_main:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
	#--------------------------------------------------------
	# Temporary disable interrupt
	#--------------------------------------------------------
disable_interrupt:				# BUG: must disable with time counter
	li $t1, COUNTER
	sb $zero, 0($t1)
	# no need to disable keyboard matrix interrupt

	#--------------------------------------------------------
	# Processing
	#--------------------------------------------------------
get_cause:
	mfc0 $t1, $13				# get cause from $13
is_counter:					# compare cause value with counter cause value
	li $t2, MASK_CAUSE_COUNTER
	and $at, $t1, $t2
	beq $at, $t2, counter_interrupt
is_keymatrix:					# compare cause value with keymatrix cause value
	li $t2, MASK_CAUSE_KEYMATRIX
	and $at, $t1, $t2
	beq $at, $t2, keymatrix_interrupt
other:
	j end_process
counter_interrupt:
	li $v0, 4
	la $a0, msg_counter
	syscall
	j end_process
keymatrix_interrupt:
	li $v0, 4
	la $a0, msg_keypress
	syscall
end_process:
	mtc0 $zero, $13				# clear CAUSE REG
	#--------------------------------------------------------
	# Re-enable interrupt
	#--------------------------------------------------------
enable_interrupt:
	li $t1, COUNTER
	sb $t1, 0($t1)
	#--------------------------------------------------------
	# Evaluate the return address of main routine
	# epc <= epc + 4
	#--------------------------------------------------------
next_pc:
	mfc0 $at, $14
	addi $at, $at, 4
	mtc0 $at, $14
return:
	eret					# return to main