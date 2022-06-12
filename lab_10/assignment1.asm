.eqv	SEVENSEG_LEFT	0xffff0011	# left seven-segment led address
.eqv	SEVENSEG_RIGHT	0xffff0010	# right seven-segment led address

.text
main:
	li $a0, 0x6f			# set value for segments
	jal show_7seg_left		# show
	li $a0, 0xcf			# set value for segments
	jal show_7seg_right		# show
exit:
	li $v0, 10
	syscall
end_main:

#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
show_7seg_left:
	li $t0, SEVENSEG_LEFT		# assign port's address
	sb $a0, 0($t0)			# assign new value
	jr $ra
#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
show_7seg_right:
	li $t0, SEVENSEG_RIGHT		# assign port's address
	sb $a0, 0($t0)			# assign new value
	jr $ra