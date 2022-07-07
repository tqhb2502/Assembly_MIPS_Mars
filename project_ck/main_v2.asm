# key
.eqv	KEYCODE		0xffff0004		# ASCII code from keyboard (1 byte)
.eqv	KEYREADY	0xffff0000		# = 1 if there is a new key code, auto clear after lw

# monitor
.eqv	MONITOR_SCREEN	0x10010000		# monitor screen's address
						# monitor config:
						# unit width in pixels: 16
						# unit height in pixels: 16
						# display width in pixels: 256
						# display height in pixels: 256

.eqv	RED		0x00ff0000		# red color
.eqv	WHITE		0x00ffffff		# white color
.eqv	BLACK		0x00000000		# black color

# snake
.data 0x10011000
	snake_unit_row: .space	32		# row of snake's unit (8 units = 32 bytes)
	snake_unit_col:	.space	32		# collumn of snake's unit (8 units = 32 bytes)
	game_over_message: .asciiz	"Game Over!"	# message when the game is over

#-----------------------------------------------------------------------
# main procedure
#-----------------------------------------------------------------------
.text
prepare_game_state:
	add $s0, $zero, $zero			# $s0 = 0 -> game over status = false
prepare_snake:
	la $s1, snake_unit_row			# $s1 = base address of snake_unit_row
	la $s2, snake_unit_col			# $s2 = base address of snake_unit_col
	li $s3, 8				# $s3 = the number of snake's units = 8
prepare_screen:
	li $s4, MONITOR_SCREEN			# $s4 = monitor screen's address

default_snake:
	li $t1, 3				# $t1 = row = 3
	li $t2, 8				# $t2 = col = 8
	add $t3, $zero, $zero			# $t3 = current unit = 0
store_default_position:
	beq $t3, $s3, display_default_position	# if $t3 == $s3 then no more unit to store, display snake
	
	sll $t4, $t3, 2				# $t4 = $t3 * 4
	add $t5, $t4, $s1			# $t5 = $t4 + $s1
	sw $t1, 0($t5)				# store $t1 to snake_unit_row[$t3]
	add $t5, $t4, $s2			# $t5 = $t4 + $s2
	sw $t2, 0($t5)				# store $t2 to snake_unit_col[$t3]
	
	addi $t2, $t2, -1			# col = col - 1
	addi $t3, $t3, 1			# current_unit = current_unit + 1
	j store_default_position
display_default_position:
	jal display_snake			# display snake on monitor

prepare_key_input:
	li $k0, KEYCODE				# $k0 = KEYCODE's address
	li $k1, KEYREADY			# $k1 = KEYREADY's address

game_loop:
	nop
update_and_display:				# else, there is a key input, update and display snake
	jal move_snake				# move snake if input is WASD
	jal display_snake			# display snake on monitor
	jal hit_border				# check if the snake hit the borders
	jal self_bite				# check if the snake bite itself
	
	bnez $s0, exit				# if game over status != false, exit
	
	li $v0, 32
	li $a0, 500
	syscall
	
	j game_loop				# continue game loop

exit:
	li $v0, 55				# show message
	la $a0, game_over_message
	li $a1, 1
	syscall
	
	li $v0, 10				# exit program
	syscall

#-----------------------------------------------------------------------
# move_snake procedure
# param[in]: $k0: key code
#	     $s1: base address of snake_unit_row
#	     $s2: base address of snake_unit_col
# param[out]:
#-----------------------------------------------------------------------
move_snake:
	sw $fp, -4($sp)				# save frame pointer
	add $fp, $zero, $sp			# adjust frame pointer
	addi $sp, $sp, -8			# adjust stack pointer
	sw $ra, 0($sp)				# save return address
get_input_key:
	lb $t0, 0($k0)				# $t0 = current key code
	
	addi $t1, $zero, 119			# $t1 = W key's code
	addi $t2, $zero, 97			# $t2 = A key's code
	addi $t3, $zero, 115			# $t3 = S key's code
	addi $t4, $zero, 100			# $t4 = D key's code
	
	beq $t0, $t1, W_key			# if current key code == W key's code, update position
	beq $t0, $t2, A_key			# if current key code == A key's code, update position
	beq $t0, $t3, S_key			# if current key code == S key's code, update position
	beq $t0, $t4, D_key			# if current key code == D key's code, update position
	b end_move_snake			# if current key code is another key code, do nothing
W_key:
	jal adjust_snake_unit			# adjust snake body
	lw $t1, 0($s1)				# $t1 = snake_unit_row[0]
	addi $t1, $t1, -1			# move up 1 row
	sw $t1, 0($s1)				# store new row back to snake_unit_row[0]
	j end_move_snake
A_key:
	jal adjust_snake_unit			# adjust snake body
	lw $t1, 0($s2)				# $t1 = snake_unit_col[0]
	addi $t1, $t1, -1			# move left 1 col
	sw $t1, 0($s2)				# store new col back to snake_unit_col[0]
	j end_move_snake
S_key:
	jal adjust_snake_unit			# adjust snake body
	lw $t1, 0($s1)				# $t1 = snake_unit_row[0]
	addi $t1, $t1, 1			# move down 1 row
	sw $t1, 0($s1)				# store new row back to snake_unit_row[0]
	j end_move_snake
D_key:
	jal adjust_snake_unit			# adjust snake body
	lw $t1, 0($s2)				# $t1 = snake_unit_col[0]
	addi $t1, $t1, 1			# move right 1 row
	sw $t1, 0($s2)				# store new col back to snake_unit_col[0]
end_move_snake:
	lw $ra, 0($sp)				# restore return address
	add $sp, $zero, $fp			# restore stack pointer
	lw $fp, -4($sp)				# restore frame pointer
	
	jr $ra					# return to calling procedure

#-----------------------------------------------------------------------
# adjust_snake_unit procedure
# param[in]: $s1: base address of snake_unit_row
#	     $s2: base address of snake_unit_col
#	     $s3: the number of snake's units
#	     $s4: monitor screen's address
# param[out]:
#-----------------------------------------------------------------------
adjust_snake_unit:
delete_last_unit:
	lw $t1, 28($s1)				# $t1 = snake_unit_row[7]
	lw $t2, 28($s2)				# #t2 = snake_unit_col[7]
	
	sll $t1, $t1, 6				# $t1 = $t1 * 64
	sll $t2, $t2, 2				# $t2 = $t2 * 4
	add $t1, $t1, $t2			# $t1 = $t1 + $t2
	add $t1, $t1, $s4			# $t1 = $t1 + monitor screen's address
	
	li $t9, BLACK				# $t9 = black color
	sw $t9, 0($t1)				# display black color at the snake's last unit
adjust_unit_position:
	addi $t0, $s3, -2			# $t0 = current unit = 6
adjust_loop:
	bltz $t0, end_adjust_snake_unit		# if $t0 < 0 then end process
	
	sll $t6, $t0, 2				# $t6 = $t0 * 4
	add $t7, $t6, $s1			# $t7 = $t6 + row base address
	lw $t1, 0($t7)				# $t1 = snake_unit_row[$t0]
	sw $t1, 4($t7)				# snake_unit_row[$t0 + 1] = $t1
	add $t7, $t6, $s2			# $t7 = $t6 + col base address
	lw $t1, 0($t7)				# $t1 = snake_unit_col[$t0]
	sw $t1, 4($t7)				# snake_unit_col[$t0 + 1] = $t1
	
	addi $t0, $t0, -1			# $t0 = $t0 - 1
	j adjust_loop				# continue loop
end_adjust_snake_unit:	
	jr $ra					# return to calling procedure

#-----------------------------------------------------------------------
# display_snake procedure
# param[in]: $s1: base address of snake_unit_row
#	     $s2: base address of snake_unit_col
#	     $s3: the number of snake's units
#	     $s4: monitor screen's address
# param[out]:
#-----------------------------------------------------------------------
display_snake:
	li $t8, RED				# $t8 = red color
	li $t9, WHITE				# $t9 = white color
snake_body:
	addi $t0, $zero, 1			# $t0 = current unit = 1
display_loop:
	beq $t0, $s3, snake_head		# if $t0 == $s3 then no more unit to display, end process
	
	sll $t6, $t0, 2				# $t6 = $t0 * 4
	add $t7, $t6, $s1			# $t7 = $t6 + row base address
	lw $t1, 0($t7)				# $t1 = snake_unit_row[$t0]
	add $t7, $t6, $s2			# $t7 = $t6 + col base address
	lw $t2, 0($t7)				# $t2 = snake_unit_col[$t0]
		
	sll $t3, $t1, 6				# $t3 = snake_unit_row[0] * 64
	sll $t4, $t2, 2				# $t4 = snake_unit_col[0] * 4
	
	add $t5, $t3, $t4			# $t5 = $t3 + $t4
	add $t5, $t5, $s4			# $t5 = $t5 + monitor screen's address
	
	sw $t8, 0($t5)				# display red unit
	
	addi $t0, $t0, 1			# $t0 = $t0 + 1
	j display_loop				# continue loop
snake_head:
	lw $t1, 0($s1)				# $t1 = snake_unit_row[0]
	lw $t2, 0($s2)				# $t2 = snake_unit_col[0]
	
	sll $t3, $t1, 6				# $t3 = snake_unit_row[0] * 64
	sll $t4, $t2, 2				# $t4 = snake_unit_col[0] * 4
	
	add $t5, $t3, $t4			# $t5 = $t3 + $t4
	add $t5, $t5, $s4			# $t5 = $t5 + monitor screen's address
	
	sw $t9, 0($t5)				# display white head
end_display_snake:
	jr $ra					# return to calling procedure

#-----------------------------------------------------------------------
# hit_border procedure
# param[in]: $s1: base address of snake_unit_row
#	     $s2: base address of snake_unit_col
#	     $s0: game over status
# param[out]: $s0: game over status, 1: true, 0: false
#-----------------------------------------------------------------------
hit_border:
	lw $t1, 0($s1)				# $t1 = snake_unit_row[0]
	lw $t2, 0($s2)				# $t2 = snake_unit_col[0]
	li $t3, 15				# $t3 = max row index = max col index = 15
	
	beqz $t1, hit_border_true		# if $t1 == 0, snake hit the top border
	beqz $t2, hit_border_true		# if $t2 == 0, snake hit the left border
	beq $t1, $t3, hit_border_true		# if $t1 == 15, snake hit the bottom border
	beq $t2, $t3, hit_border_true		# if $t2 == 15, snake hit the right border
	b end_hit_border			# else, snake does not hit border
hit_border_true:
	addi $s0, $zero, 1			# $s0 = 1 -> game over status = true
end_hit_border:
	jr $ra					# return to calling procedure

#-----------------------------------------------------------------------
# self_bite procedure
# param[in]: $s1: base address of snake_unit_row
#	     $s2: base address of snake_unit_col
#	     $s3: the number of snake's units
#	     $s0: game over status
# param[out]: $s0: game over status, 1: true, 0: false
#-----------------------------------------------------------------------
self_bite:
head_coordinates:				# get snake's head coordinates
	lw $t1, 0($s1)				# $t1 = snake_unit_row[0]
	lw $t2, 0($s2)				# $t2 = snake_unit_col[0]
check_body_units:				# check if the snake bite itself (body unit's coordinates == head coordinates)
	addi $t3, $zero, 1			# $t3 = current unit = 1
self_bite_check_loop:
	beq $t3, $s3, end_self_bite		# if $t3 == number of units, end process
	
	sll $t4, $t3, 2				# $t4 = current unit * 4
	add $t5, $t4, $s1			# $t5 = $t4 + row base address
	lw $t6, 0($t5)				# $t6 = snake_unit_row[$t3]
	add $t5, $t4, $s2			# $t5 = $t4 + col base address
	lw $t7, 0($t5)				# $t7 = snake_unit_col[$t3]
	
	bne $t1, $t6, self_bite_check_continue	# if snake_unit_row[0] != snake_unit_row[$t3], check the next unit
	bne $t2, $t7, self_bite_check_continue	# if snake_unit_col[0] != snake_unit_col[$t3], check the next unit
	j self_bite_true			# else, snake_unit_row[0] == snake_unit_row[$t3]
						#       and snake_unit_col[0] == snake_unit_col[$t3]
						# -> the snake has bitten ifself
self_bite_check_continue:
	addi $t3, $t3, 1			# current unit = current unit + 1
	j self_bite_check_loop			# continue the loop
self_bite_true:
	addi $s0, $zero, 1			# $s0 = 1 -> game over status = true
end_self_bite:
	jr $ra					# return to calling procedure
	
	
	
	
