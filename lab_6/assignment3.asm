# lab 6, assignment 3

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
end_of_main:

#--------------------------------------------------------------
#procedure sort (ascending bubble sort using pointer)
#register usage in sort program
#$a0 pointer to the first element in unsorted part
#$a1 pointer to the last element in unsorted part
#--------------------------------------------------------------
sort:
	beq $a0, $a1, done						# if the list has 1 element, done
	add $v0, $zero, $a0						# v0 = address of A[0]
bubble:
	lw $t1, 0($v0)							# t1 = A[i]
	lw $t2, 4($v0)							# t2 = A[i+1]
	slt $t0, $t1, $t2						# if A[i] < A[i+1] then t0 = 1
	beq $t0, $zero, swap						# if A[i] >= A[i+1] then swap
check:
	addi $v0, $v0, 4						# v0 = address of next element
	bne $v0, $a1, bubble						# if v0 != a1 then continue bubble sort
after_bubble:
	addi $a1, $a1, -4						# decrement pointer to next last element
	j sort								# continue sorting
done:
	j after_sort
	
#------------------------------------------------------------------------
#Procedure swap
#function: swap 2 element based on their address
#$v0 pointer to first element
#$t1 value of first element
#$t2 value of second element
#------------------------------------------------------------------------
swap:
	sw $t1, 4($v0)							# store A[i] to address of A[i+1]
	sw $t2, 0($v0)							# store A[i+1] to address of A[i]
end_of_swap:
	j check