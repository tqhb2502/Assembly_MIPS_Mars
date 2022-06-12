.eqv	IN_ADDRESS_HEXA_KEYBOARD	0xFFFF0012

.data
message:	.asciiz "Oh my god. Someone's presed a button.\n"

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
	li $t3, 0x80					# bit 7 = 1 to enable interrupt
	sb $t3, 0($t1)
	
	#---------------------------------------------------------
	# No-end loop, main program, to demo the effective of interrupt
	#---------------------------------------------------------
loop:
	li $v0, 32
	li $a0, 300
	syscall
	nop
	j loop
end_main:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
	#--------------------------------------------------------
	# Processing
	#--------------------------------------------------------
IntSR:
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 34
	mfc0 $a0, $14
	syscall
	#--------------------------------------------------------
	# Evaluate the return address of main routine
	# epc = epc + 4
	#--------------------------------------------------------
next_pc:
	mfc0 $at, $14					# current instruction address
	addi $at, $at, 4				# next instruction address
	mtc0 $at, $14					# store back in $14 of C0
return:
	eret						# return to main
