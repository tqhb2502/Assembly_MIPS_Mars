# lab 7 assignment 2

.text
main:
	li $a0, 102					# load parameters
	li $a1, 89
	li $a2, 100
	jal max						# call max procedure
	add $s0, $zero, $v0
	
	li $v0, 10					# terminate
	syscall
endmain:

#----------------------------------------------------------------------
#Procedure max: find the largest of three integers
#param[in] $a0 integers
#param[in] $a1 integers
#param[in] $a2 integers
#return $v0 the largest value
#----------------------------------------------------------------------
max:
	add $v0, $zero, $a0				# v0 = a0
	slt $t0, $v0, $a1				# if v0 < a1 then t0 = 1
	beq $t0, $zero, okay				# if v0 >= a1 then okay
	add $v0, $zero, $a1				# else v0 = a1
okay:
	slt $t0, $v0, $a2				# if v0 < a2 then t0 = 1
	beq $t0, $zero, done				# if v0 >= a2 then done
	add $v0, $zero, $a2				# else v0 = a2
done:
	jr $ra						# return to calling program