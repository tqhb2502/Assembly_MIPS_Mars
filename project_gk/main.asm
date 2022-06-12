# Mini project giua ky
# Nhom 9:
# Tran Quang Huy - 20190093
# Tran Cao Minh - 20194623
# Bai 1

.data
	message1:	.asciiz "So nguyen thu 1:"
	message2:	.asciiz "So nguyen thu 2:"
	
	message_out1:	.asciiz "So nguyen thu 1 la: "
	message_out2:	.asciiz "So nguyen thu 2 la: "
	
	message_gcd:	.asciiz "Uoc chung lon nhat la: "
	message_lcm:	.asciiz "Boi chung nho nhat la: "
	
	message_ok:	.asciiz "Nhap du lieu thanh cong!"
	message_can_not_parse:	.asciiz "Du lieu nhap vao khong phai so nguyen 32 bit!"
	message_cancel:	.asciiz "Ban da chon cancel!"
	message_no_data_input:	.asciiz "Khong co du lieu gi duoc nhap vao!"
	message_less_than_zero:	.asciiz "Du lieu nhap vao phai la so nguyen duong!"
	
	message_limit_exceeded:	.asciiz "Boi chung nho nhat vuot qua gia tri cho phep (32 bit)!"

.text
#----------------------------------------------------------------------
# procedure main: chuong trinh chinh
#----------------------------------------------------------------------
main:
first_number:				# nhap so thu 1
	li $v0, 51
	la $a0, message1
	syscall
	jal input_checker		# kiem tra du lieu nhap vao
	seq $t0, $v0, 1			# neu v0 == 1, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, first_number	# v0 == 1, yeu cau nhap lai
	seq $t0, $v0, 2			# neu v0 == 2, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, quit		# v0 == 2, ket thuc chuong trinh
	# v0 == 0, tiep tuc chuong trinh
	add $s0, $zero, $a0		# s0 = A

second_number:				# nhap so thu 2
	li $v0, 51
	la $a0, message2
	syscall
	jal input_checker		# kiem tra du lieu nhap vao
	seq $t0, $v0, 1			# neu v0 == 1, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, second_number	# v0 == 1, yeu cau nhap lai
	seq $t0, $v0, 2			# neu v0 == 2, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, quit		# v0 == 2, ket thuc chuong trinh
	# v0 == 0, tiep tuc chuong trinh
	add $s1, $zero, $a0		# s1 = B

copy:					# copy A, B ra thanh ghi t0, t1
	add $t0, $zero, $s0		# t0 = A
	add $t1, $zero, $s1		# t1 = B

find_gcd:				# tim uoc chung lon nhat
	div $t0, $t1			# A / B, lo = thuong, hi = so du
	add $t0, $zero, $t1		# A = B
	mfhi $t1			# B = so du
	bne $t1, $zero, find_gcd	# neu B != 0, tiep tuc lap
	add $s2, $zero, $t0		# neu B == 0, da tim duoc UCLN, s2 = UCLN = A

find_lcm:				# tim boi chung nho nhat
	div $s0, $s2			# A / UCLN, lo = thuong, hi = so du = 0
	mflo $t0			# t0 = A / UCLN
	mult $t0, $s1			# (A / UCLN) * B, hi = 32 bit cao, lo = 32 bit thap
	mflo $s3			# s3 = 32 bit thap
	mfhi $s4			# s4 = 32 bit cao

output:					# in ra ket qua
	li $v0, 56			# in so nguyen thu 1
	la $a0, message_out1
	add $a1, $zero, $s0
	syscall

	li $v0, 56			# in so nguyen thu 2
	la $a0, message_out2
	add $a1, $zero, $s1
	syscall

	li $v0, 56			# in uoc chung lon nhat
	la $a0, message_gcd
	add $a1, $zero, $s2
	syscall
	
	bne $s4, $zero, limit_exceeded	# kiem tra gia tri 32 bit cao co bang 0 hay khong?
	li $v0, 56			# neu bang 0, in BCNN = gia tri 32 bit thap
	la $a0, message_lcm
	add $a1, $zero, $s3
	syscall
	j quit				# ket thuc chuong trinh

limit_exceeded:				# neu khac 0, BCNN vuot qua gia tri cho phep (32 bit)
	li $v0, 55			# in thong bao
	la $a0, message_limit_exceeded
	li $a1, 2
	syscall

quit:					# ket thuc chuong trinh
	li $v0, 10
	syscall
end_of_main:

#----------------------------------------------------------------------
# procedure input_checker: kiem tra xem du lieu nhap vao co hop le
# param[in]: $a1 tinh trang du lieu nhap vao
# param[out]: $v0 xu ly tiep theo cua chuong trinh
#	0: tiep tuc thuc hien chuong trinh binh thuong
#	1: yeu cau nhap lai du lieu
#	2: ket thuc chuong trinh
#----------------------------------------------------------------------
input_checker:
	addi $sp, $sp, -4		# dieu chinh thanh ghi sp
	sw $a0, 0($sp)			# luu tru gia tri thanh ghi a0

	seq $t0, $a1, -1		# neu a1 == -1, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, CAN_NOT_PARSE	# a1 == -1, du lieu nhap vao khong phai so nguyen
	seq $t0, $a1, -2		# neu a1 == -2, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, CANCEL		# a1 == -2, da chon cancel
	seq $t0, $a1, -3		# neu a1 == -3, t0 = 1, nguoc lai, t0 = 0
	bne $t0, $zero, NO_DATA_INPUT	# a1 == -3, khong co du lieu gi duoc nhap vao
	ble $a0, $zero, LESS_THAN_ZERO	# a0 <= 0, du lieu nhap vao phai lon hon 0
	# a1 == 0, du lieu nhap vao thanh cong
OK:
	li $v0, 55			# in thong bao
	la $a0, message_ok
	li $a1, 1
	syscall
	li $v0, 0			# v0 = 0, tiep tuc chuong trinh
	j done				# ket thuc chuong trinh con
CAN_NOT_PARSE:
	li $v0, 55			# in thong bao
	la $a0, message_can_not_parse
	li $a1, 2
	syscall
	li $v0, 1			# v0 = 1, yeu cau nhap lai du lieu
	j done				# ket thuc chuong trinh con
CANCEL:
	li $v0, 55			# in thong bao
	la $a0, message_cancel
	li $a1, 1
	syscall
	li $v0, 2			# v0 = 2, ket thuc chuong trinh
	j done				# ket thuc chuong trinh con
NO_DATA_INPUT:
	li $v0, 55			# in thong bao
	la $a0, message_no_data_input
	li $a1, 2
	syscall
	li $v0, 1			# v0 = 1, yeu cau nhap lai du lieu
	j done				# ket thuc chuong trinh con
LESS_THAN_ZERO:
	li $v0, 55			# in thong bao
	la $a0, message_less_than_zero
	li $a1, 2
	syscall
	li $v0, 1			# v0 = 1, yeu cau nhap lai du lieu
done:
	lw $a0, 0($sp)			# khoi phuc gia tri cho thanh ghi a0
	addi $sp, $sp, 4		# dieu chinh lai thanh ghi sp ve gia tri ban dau
	jr $ra				# quay ve chuong trinh goi
end_of_input_checker:
