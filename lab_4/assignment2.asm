# lab 4, assignment 2

.text								# instructions
	li $s0, 0x12345678					# load value for $s0
	andi $t0, $s0, 0xff000000				# extract MSB of $s0
	andi $s0, $s0, 0xffffff00				# clear LSB of $s0
	ori $s0, $s0, 0x000000ff				# set LSB of $s0 to 1
	andi $s0, $s0, 0x00000000				# clear $s0 ($s0 = 0)