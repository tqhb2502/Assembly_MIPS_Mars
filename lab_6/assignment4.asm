# lab 6, assignment 4

.data
	A:	.word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
	
.text
	la $a0, A				# a0 = address of A[0]
	li $a1, 13				# the number of elements
	j prepare
after_sort:
	li $v0, 10				# exit
	syscall
end_of_main:

#--------------------------------------------------------------
#procedure sort (ascending insertion sort using index)
#register usage in sort program
#$a0 pointer to the first element in the array
#$a1 the number of elements in the array
#--------------------------------------------------------------
prepare:
	add $t0, $zero, $zero			# t0 = i = 0 (index of current element)
sort:
	beq $t0, $a1, done			# i == n, done
	
	add $t1, $t0, $t0			# t1 = 2 * i
	add $t1, $t1, $t1			# t1 = 4 * i
	add $t2, $t1, $a0			# t2 = address of A[i]
	lw $t3, 0($t2)				# t3 = A[i]
	
	addi $s0, $t0, -1			# s0 = j = i - 1 (position index, run backward)
find_position:
	bltz $s0, assign			# if j < 0, assign A[i] to index j + 1
	
	add $t1, $s0, $s0			# t1 = 2 * j
	add $t1, $t1, $t1			# t1 = 4 * j
	add $t2, $t1, $a0			# t2 = address of A[j]
	lw $t4, 0($t2)				# t4 = A[j]
	
	slt $t5, $t3, $t4			# if A[i] < A[j] then t5 = 1
	beq $t5, $zero, assign			# if A[i] >= A[j], assign A[i] to index j + 1
	
	sw $t4, 4($t2)				# store A[j] to index j + 1
	addi $s0, $s0, -1			# j = j - 1
	j find_position				# continue finding
assign:
	add $t1, $s0, $s0			# t1 = 2 * j
	add $t1, $t1, $t1			# t1 = 4 * j
	add $t2, $t1, $a0			# t2 = address of A[j]

	sw $t3, 4($t2)				# store A[i] to index j + 1
	addi $t0, $t0, 1			# i = i + 1
	j sort					# continue sorting
done:
	j after_sort