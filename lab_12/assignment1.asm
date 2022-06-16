# lab 7 assignment 4

.data
	message:	.asciiz "Ket qua tinh giai thua la: "

.text
main:
	jal warp					# call warp procedure
print:
	add $a1, $v0, $zero				# a1 = result from fact(N)
	li $v0, 56
	la $a0, message
	syscall
quit:							# terminate
	li $v0, 10
	syscall
end_main:

#----------------------------------------------------------------------
#Procedure WARP: assign value and call FACT
#----------------------------------------------------------------------
warp:
	sw $fp, -4($sp)					# save fp
	add $fp, $zero, $sp				# fp = sp
	addi $sp, $sp, -8				# adjust sp
	sw $ra, 0($sp)					# save ra
	
	li $a0, 6					# load input parameter
	jal fact					# call fact procedure
	nop
	
	lw $ra, 0($sp)					# restore ra
	add $sp, $zero, $fp				# restore sp
	lw $fp, -4($sp)					# resotre fp
	jr $ra						# return to calling program
end_warp:

#----------------------------------------------------------------------
#Procedure FACT: compute N!
#param[in] $a0 integer N
#return $v0 the largest value
#----------------------------------------------------------------------
fact:
	sw $fp, -4($sp)					# save fp
	add $fp, $zero, $sp				# fp = sp
	addi $sp, $sp, -12				# adjust sp
	sw $ra, 4($sp)					# save ra
	sw $a0, 0($sp)					# save N
	
	slti $t0, $a0, 2				# if N < 2 then t0 = 1
	beq $t0, $zero, recursive			# if N >= 2 then continue recursion
	nop
	addi $v0, $zero, 1				# else result = 1
	j done
	nop
recursive:
	addi $a0, $a0, -1				# N = N - 1
	jal fact					# recursive call
	nop
	
	lw $v1, 0($sp)					# restore N
	mult $v0, $v1					# calculate result
	mflo $v0
done:
	lw $a0, 0($sp)					# restore N
	lw $ra, 4($sp)					# restore ra
	add $sp, $fp, $zero				# restore sp
	lw $fp, -4($sp)					# restore fp
	jr $ra						# return to calling procedure
end_fact: