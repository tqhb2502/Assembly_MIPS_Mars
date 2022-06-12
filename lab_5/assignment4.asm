# lab 5, assignment 4
.data
	string:		.space 50
	message1:	.asciiz "Nhap xau: "
	message2:	.asciiz "Do dai xau la: "
.text
main:
get_string:						# input string
	li $v0, 54
	la $a0, message1
	la $a1, string
	li $a2, 50
	syscall
get_length:
	add $s0, $zero, $zero				# s0 = i = 0
	la $t0, string					# t0 = base address of string
check_char:
	add $t1, $t0, $s0				# t1 = base address + i = address of string[i]
	lb $t2, 0($t1)					# t2 = string[i]
	beq $t2, $zero, end_of_str			# if t2 == 0, exit
	addi $s0, $s0, 1				# i = i + 1
	j check_char					# deal with next character
end_of_str:
	sub $s0, $s0, 1					# minus 1 from the length because of next line character
end_of_get_length:
print_length:
	li $v0, 56					# print the length of string
	la $a0, message2
	add $a1, $zero, $s0
	syscall