.eqv	KEY_CODE	0xffff0004		# ASCII code from keyboard (1 byte)
.eqv	KEY_READY	0xffff0000		# = 1 if has a new key code
						# auto clear after lw
					
.eqv	DISPLAY_CODE	0xffff000c		# ASCII code to show (1 byte)
.eqv	DISPLAY_READY	0xffff0008		# = 1 if the display has already to do
						# auto clear after sw
					
.eqv	MASK_CAUSE_KEYBOARD	0x00000034	# keyboard cause

#---------------------------------------------------------------
# Main procedure
#---------------------------------------------------------------
.text
	li $k0, KEY_CODE
	li $k1, KEY_READY
	
	li $s0, DISPLAY_CODE
	li $s1, DISPLAY_READY

loop:
	nop
wait_for_key:	
	lw $t1, 0($k1)				# $t1 = [$k1] = KEY_READY
	beq $t1, $zero, wait_for_key		# if $t1 == 0 then continue waiting
make_interrupt:
	teqi $t1, 1				# if $t1 == 1 then raise an interrupt
	b loop

#---------------------------------------------------------------
# Interrupt subroutine
#---------------------------------------------------------------
.ktext 0x80000180
get_cause:
	mfc0 $t1, $13
is_keyboard:					# check if this is keyboard interrupt
	li $t2, MASK_CAUSE_KEYBOARD
	and $at, $t1, $t2
	beq $at, $t2, keyboard_interrupt
other:
	j end_process
	
keyboard_interrupt:
read_key:
	lw $t0, 0($k0)				# $t0 = [$k0] = KEY_CODE
wait_for_display:
	lw $t2, 0($s1)				# $t2 = [$s1] = DISPLAY_READY
	beq $t2, $zero, wait_for_display	# if $t2 == 0 then continue waiting
#encrypt:
#	addi $t0, $t0, 1			# change input key
show_key:
	sw $t0, 0($s0)				# show key
	nop
end_process:
next_pc:					# next instruction
	mfc0 $at, $14
	addi $at, $at, 4
	mtc0 $at, $14
return:						# return to main
	eret
