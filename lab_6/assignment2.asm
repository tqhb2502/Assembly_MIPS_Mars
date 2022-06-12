# lab 6, assignment 2

.data
	A:	.word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
	Aend:	.word

.text
main:
	la $a0, A							# a0 = address of A[0]
	la $a1, Aend
	addi $a1, $a1, -4						# a1 = address of A[n-1]
	j sort
after_sort:
	li $v0, 10							# exit
	syscall
end_main:

#--------------------------------------------------------------
#procedure sort (ascending selection sort using pointer)
#register usage in sort program
#$a0 pointer to the first element in unsorted part
#$a1 pointer to the last element in unsorted part
#$t0 temporary place for value of last element
#$v0 pointer to max element in unsorted part
#$v1 value of max element in unsorted part
#--------------------------------------------------------------
sort:
	beq $a0, $a1, done						# if the list has only 1 element, done
	j max								# find max value
after_max:
	lw $t0, 0($a1)							# t0 = last element
	sw $v1, 0($a1)							# store max value to last element's address
	sw $t0, 0($v0)							# store value of ex-last element to max pointer
	addi $a1, $a1, -4						# decrement pointer to next last element
	j sort								# continue sorting	
done:
	j after_sort

#------------------------------------------------------------------------
#Procedure max
#function: fax the value and address of max element in the list
#$a0 pointer to first element
#$a1 pointer to last element
#------------------------------------------------------------------------
max:
	addi $v0, $a0, 0						# max pointer v0, default: v0 = address of A[0]
	lw $v1, 0($v0)							# max value v1, default: v1 = A[0]
	addi $t0, $a0, 0						# next pointer
loop:
	beq $t0, $a1, ret						# if pointer is pointing to the last element, end procedure
	addi $t0, $t0, 4						# t0 = address of next element A[i]
	lw $t1, 0($t0)							# t1 = A[i]
	slt $t2, $t1, $v1						# if A[i] < max value then t2 = 1
	bne $t2, $zero, loop						# if A[i] < max value, do nothing, loop to deal with the next element
	add $v0, $zero, $t0						# max pointer = address of A[i]
	add $v1, $zero, $t1						# max value = A[i]
	j loop								# loop to deal with the next element
ret:
	j after_max							# found max value, continue sort
