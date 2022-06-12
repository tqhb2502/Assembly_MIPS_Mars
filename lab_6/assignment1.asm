# lab 6, assignment 1

.data
	A:	.word 2, -3, 2, 5, -4

.text
main:
	la $a0, A						# a0 = base address of array A
	li $a1, 5						# a1 = the number of the elements of A
	j mspfx							# go to procedure mspfx
	nop
continue:
lock:
end_of_main:
	j end_of_text						# end this program

#-----------------------------------------------------------------
#Procedure mspfx
# @brief find the maximum-sum prefix in a list of integers
# @param[in] a0 the base address of this list(A) need to be processed
# @param[in] a1 the number of elements in list(A)
# @param[out] v0 the length of sub-array of A in which max sum reachs.
# @param[out] v1 the max sum of a certain sub-array
#-----------------------------------------------------------------
#Procedure mspfx
#function: find the maximum-sum prefix in a list of integers
#the base address of this list(A) in $a0 and the number of
#elements is stored in a1
mspfx:
	addi $v0, $zero, 0						# length of the prefix
	addi $v1, $zero, 0						# max prefix sum
	addi $t0, $zero, 0						# index i
	addi $t1, $zero, 0						# running sum
loop:
	add $t2, $t0, $t0					# t2 = 2i
	add $t2, $t2, $t2					# t2 = 4i
	add $t3, $t2, $a0					# t3 = address of A[i]
	lw $t4, 0($t3)						# t4 = A[i]
	add $t1, $t1, $t4					# add A[i] to running sum
	slt $t5, $v1, $t1					# if max sum < running sum then t5 = 1
	bne $t5, $zero, mdfy					# if max sum < running sum then modify
	j test							# if max sum >= running sum then do not modify, move to the next element
mdfy:
	addi $v0, $t0, 1					# prefix length = i + 1
	add $v1, $zero, $t1					# max sum = running sum
test:
	addi $t0, $t0, 1					# i = i + 1
	slt $t5, $t0, $a1					# if i < n then t5 = 1
	bne $t5, $zero, loop					# if i < n then continue loop
done:
	j continue						# end procedure, back to main
mspfx_end:

end_of_text: