# lab 5, assignment 5
.data
	reverseString:	.space 22			# reverse string of input string (include null character)
	message:	.asciiz "Xau dao nguoc la: "
.text
	la $s0, reverseString				# s0 = base address of reverseString
	addi $s0, $s0, 21				# s0 = base address + length = address of the last byte of reverseString
	sb $zero, 0($s0)				# store null character to the last byte of reverseString
	
	addi $s1, $zero, 1				# s1 = i = 1
	
	addi $t1, $zero, 22				# t1 = string length = 22 (include null character)
	addi $t2, $zero, 0x0a				# t2 = new line ascii code
input:
	li $v0, 12					# get 1 character from standard input
	syscall
	beq $v0, $t2, end_of_input			# if input character == new line, exit
	
	sub $t0, $s0, $s1				# t0 = s0 - s1 = last byte address - i
	sb $v0, 0($t0)					# store character to its address
	
	addi $s1, $s1, 1				# i = i + 1
	beq $s1, $t1, end_of_input			# if i == 22, exit
	
	j input						# input next character
end_of_input:
print_reverse_string:
	li $v0, 59					# print reverse string of input string
	la $a0, message
	add $a1, $zero, $t0
	syscall
	