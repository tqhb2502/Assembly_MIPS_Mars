# lab 7 assignment 1

.text
main:
	li $a0, -89					# load input parameter
	jal abs						# call abs procedure
	add $s0, $zero, $v0
	
	li $v0, 10					# terminate
	syscall
endmain:

#--------------------------------------------------------------------
# function abs
# param[in] $a0 the interger need to be gained the absolute value
# return $v0 absolute value
#--------------------------------------------------------------------
abs:
	sub $v0, $zero, $a0				# v0 = 0 - a0
	bltz $a0, done					# if a0 < 0 then done
	add $v0, $zero, $a0				# else v0 = a0
done:
	jr $ra						# return to calling program