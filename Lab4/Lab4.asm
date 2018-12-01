###########################################################################
# Created by: Shen, Jinghao
#             jshen30
#             18 Nov, 2018
#
# Assignment: Lab 4
#             CMPE 012, Computer Systems and Assembly Language
#             UC Santa Cruz, Fall 2018
#
# Description:
#
# Notes:
###########################################################################

#pseudocode:
# read the input from the program arguments
# if numbers is not between -64 and 63 
# 	print "invalid numbers"
# 	return
# else
# 	print out the numbers
# 	covert the numbers into 32-bit two's complement numbers
# 	$s1 = first number
#	$s2 = second number
#	$s0 = first number + second number
#	print out the sum as decimal
#	covert the sum into 32-bit two's complement number
#	print out the sum as 32-bit two's complement number
#
#	if first bit of the sum is 1
#		print out "-" and space in Morse code
#		
#	print the value of the sum in Morse code
# end if	

# $t0: temper
# $t1: Sign of A
# $t2: second digit of A
# $t3: first digit of A
# $t4: Sign of B
# $t5: second digit of B
# $t6: first digit of B
# $t7: Sign of the sum
# $t8: second digit of the sum
# $t9: first digit of the sum
.data 
	Z: .asciiz "0000"
	O: .asciiz "0001"
	TW: .asciiz "0010"
	TH: .asciiz "0011"
	FO: .asciiz "0100"
	FI: .asciiz "0101"
	SIX: .asciiz "0110"
	SIV: .asciiz "0111"
	EI: .asciiz "1000"
	N: .asciiz "1001"
	A: .asciiz "1010"
	B: .asciiz "1011"
	C: .asciiz "1100"
	D: .asciiz "1101"
	E: .asciiz "1110"
	F: .asciiz "1111"
	input: .asciiz "You entered the decimal numbers:\n"
	sum: .asciiz "The sum in decial is:\n"
	bSum: .asciiz "The sum in two's complement binary is:\n"
	mSum: .asciiz "The sum in Morse code is:\n"
	space: .asciiz " "
	nextLine: .asciiz "\n"
	one: .asciiz "1"
	zero: .asciiz "0"
	morse0: .asciiz "----- "
	morse1: .asciiz ".---- "
	morse2: .asciiz "..--- "
	morse3: .asciiz "...-- "
	morse4: .asciiz "....- "
	morse5: .asciiz "..... "
	morse6: .asciiz "-.... "
	morse7: .asciiz "--... "
	morse8: .asciiz "---.. "
	morse9: .asciiz "----. "
	morseS: .asciiz "-...- "
.text
	main:
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 4                                          #print out num A
	lw $a0, ($a1)                                 
	syscall
	lb $t1, ($a0)                                      #get the sign of A 
		bne $t1, 0x0000002d, posA
		lb $t2, 2($a0)                             #When A is negative
			bnez $t2, DDL1                     #check if it's two digits long
			lb $t3, 1($a0)                     #get the digit
			sub $t3, $t3, 0x00000030
			b end_ifa
		DDL1:	                                   #two digits long
			lb $t2, 1($a0)
			sub $t2, $t2, 0x00000030           #get the first digit as int
			lb $t3, 2($a0)
			sub $t3, $t3, 0x00000030           #get the second digit as int
			b end_ifa	
	posA: 
		addi $t1, $zero, 0                         #when positive set sign to 0
		lb $t2, 1($a0)                             
			bnez $t2, DDL2                     #check if it's two digits long
			lb $t3, ($a0)
			sub $t3, $t3, 0x00000030
			b end_ifa
		DDL2:	 
			lb $t2, 0($a0)
			sub $t2, $t2, 0x00000030
			lb $t3, 1($a0)
			sub $t3, $t3, 0x00000030
			b end_ifa
	end_ifa:
	
	li $v0, 4                                         #space
	la $a0, space
	syscall
	
	li $v0, 4                                         #print out num B
	lw $a0, 4($a1)
	syscall
	lb $t4, ($a0)                                     #get the sign of B 
		bne $t4, 0x0000002d, posB                 #same process as A but store in different registor
		lb $t5, 2($a0)
			bnez $t5, DDL3
			lb $t6, 1($a0)
			sub $t6, $t6, 0x00000030
			b end_ifb
		DDL3:	 
			lb $t5, 1($a0)
			sub $t5, $t5, 0x00000030
			lb $t6, 2($a0)
			sub $t6, $t6, 0x00000030
			b end_ifb	
	posB: 
		addi $t4, $zero, 0
		lb $t5, 1($a0)
			bnez $t5, DDL4
			lb $t6, ($a0)
			sub $t6, $t6, 0x00000030
			b end_ifb
		DDL4:	 
			lb $t5, ($a0)
			sub $t5, $t5, 0x00000030
			lb $t6, 1($a0)
			sub $t6, $t6, 0x00000030
			b end_ifb
	end_ifb:
	
	li $v0, 4                                           #switch lines
	la $a0, nextLine
	syscall
	li $v0, 4
	la $a0, nextLine
	syscall
	
	mul $t2, $t2, 10                                    #convert number A into int
	add $t2, $t2, $t3 
		bne $t1, 0x0000002d, end_if_aa
		sub $t2, $zero, $t2
	end_if_aa:
	
	abs $t0, $t2                                        #convert A to 2SC and in $s1
	add $s1, $t0, $zero
		bne $t1, 0x0000002d, end_if_sign_a
		xori $s1, 0xffffffff                        #if negative reverse then +1
		addi $s1, $s1, 1
	end_if_sign_a:
	
	
	mul $t5, $t5, 10                                    #convert number B into int
	add $t5, $t5, $t6 
		bne $t4, 0x0000002d, end_if_bb
		sub $t5, $zero, $t5
	end_if_bb:

	abs $t0, $t5                                        #convert B to 2SC and in $s2
	add $s2, $t0, $zero
		bne $t4, 0x0000002d, end_if_sign_b
		xori $s2, 0xffffffff
		addi $s2, $s2, 1
	end_if_sign_b:

	add $t8, $t2, $t5                                   #sum two int
	abs $t0, $t8
	add $s0, $t0, $zero                                 #store the abs value of sum into $s0
	
		bgez $t8, sum_sign                          #set $t7 (sign) to 0x0000002d if the sum < 0
		add $t7, $zero, 0x0000002d
		mul $t8, $t8, -1
	sum_sign:
	
		bne $t7, 0x0000002d, end_if_sign_s          #reverse $s0 then +1 if negative
		xori $s0, 0xffffffff
		addi $s0, $s0, 1
	end_if_sign_s:
	
	div $t8, $t8, 10                                   #get the digits of sum
	mfhi $t9
	add $t8, $t8, 0x00000030                           #if 2nd digit is 0, print null
		bne $t8, 0x00000030, sum_zero
		add $t8, $zero, $zero
	sum_zero:
	add $t9, $t9, 0x00000030
	
	li $v0, 4                                          #print sum in decimal
	la $a0, sum
	syscall	
	li $v0, 11
	add $a0, $zero, $t7
	syscall
	li $v0, 11
	add $a0, $zero, $t8
	syscall
	li $v0, 11
	add $a0, $zero, $t9
	syscall
	
	li $v0, 4                                          #switch lines
	la $a0, nextLine
	syscall
	li $v0, 4
	la $a0, nextLine
	syscall

	li $v0, 4                                          #print sum in binary
	la $a0, bSum
	syscall
	
	addi $t0, $zero, 0                                 #print the sign in binary
		bne $t7, 0x0000002d, else_sign_binary
		start_loop_1:
			beq $t0, 16, end_loop_1
			li $v0, 4
			la $a0, one
			syscall
			addi $t0, $t0, 1
			b start_loop_1 
		end_loop_1:
		b end_if_sign_binary
	else_sign_binary:
		start_loop_2:
			beq $t0, 16, end_loop_2
			li $v0, 4
			la $a0, zero
			syscall
			addi $t0, $t0, 1
			b start_loop_2
		end_loop_2:
		b end_if_sign_binary
	end_if_sign_binary:
	
	la $a1, 0x10010000                                 #get the address of data
	and $t0, $s0, 0x000000ff                           #get rid of "f"s
	div $t0, $t0, 16                                   #get the num on 0x000000?0 
	mul $t0, $t0, 5
	add $a1, $a1, $t0                                  #go to the address of that num

	li $v0, 4                                          #print the num in binary
	la $a0, ($a1)
	syscall
	
	la $a1, 0x10010000
	and $t0, $s0, 0x000000ff
	div $t0, $t0, 16
	mfhi $t0                                           #get the number on 0x0000000?
	mul $t0, $t0, 5
	la $a1, 0x10010000
	add $a1, $a1, $t0

	li $v0, 4                                          #print the num in binary
	la $a0, ($a1)
	syscall
	

	li $v0, 4                                          #switch lines
	la $a0, nextLine
	syscall
	li $v0, 4
	la $a0, nextLine
	syscall
	
	li $v0, 4                                          #print Morse code
	la $a0, mSum
	syscall
		bne $t7, 0x0000002d, end_m_sign
		li $v0, 4
		la $a0, morseS
		syscall                                    #print sign if negative
	end_m_sign:
		beqz $t8, else
		sub $t8, $t8, 0x00000030
	else:
	sub $t9, $t9, 0x00000030
		
		beq $t8, 0, end_if_m_a                    #print the first digit in Morse code
		bne $t8, 1, else_m_2_a
		li $v0, 4
		la $a0, morse1
		syscall
		b end_if_m_a
	else_m_2_a:
		bne $t8, 2, else_m_3_a
		li $v0, 4
		la $a0, morse2
		syscall
		b end_if_m_a
	else_m_3_a:
		bne $t8, 3, else_m_4_a
		li $v0, 4
		la $a0, morse3
		syscall
		b end_if_m_a
	else_m_4_a:
		bne $t8, 4, else_m_5_a
		li $v0, 4
		la $a0, morse4
		syscall
		b end_if_m_a
	else_m_5_a:
		bne $t8, 5, else_m_6_a
		li $v0, 4
		la $a0, morse5
		syscall
		b end_if_m_a
	else_m_6_a:
		bne $t8, 6, else_m_7_a
		li $v0, 4
		la $a0, morse6
		syscall
		b end_if_m_a
	else_m_7_a:
		bne $t8, 7, else_m_8_a
		li $v0, 4
		la $a0, morse7
		syscall
		b end_if_m_a
	else_m_8_a:
		bne $t8, 8, else_m_9_a
		li $v0, 4
		la $a0, morse8
		syscall
		b end_if_m_a
	else_m_9_a:
		li $v0, 4
		la $a0, morse9
		syscall
		b end_if_m_a
	end_if_m_a:
	
		bne $t9, 0, else_m_1_b                     #print the second digit in Morse code
		li $v0, 4
		la $a0, morse0
		syscall
		b end_if_m_b
	else_m_1_b:
		bne $t9, 1, else_m_2_b
		li $v0, 4
		la $a0, morse1
		syscall
		b end_if_m_b
	else_m_2_b:
		bne $t9, 2, else_m_3_b
		li $v0, 4
		la $a0, morse2
		syscall
		b end_if_m_b
	else_m_3_b:
		bne $t9, 3, else_m_4_b
		li $v0, 4
		la $a0, morse3
		syscall
		b end_if_m_b
	else_m_4_b:
		bne $t9, 4, else_m_5_b
		li $v0, 4
		la $a0, morse4
		syscall
		b end_if_m_b
	else_m_5_b:
		bne $t9, 5, else_m_6_b
		li $v0, 4
		la $a0, morse5
		syscall
		b end_if_m_b
	else_m_6_b:
		bne $t9, 6, else_m_7_b
		li $v0, 4
		la $a0, morse6
		syscall
		b end_if_m_b
	else_m_7_b:
		bne $t9, 7, else_m_8_b
		li $v0, 4
		la $a0, morse7
		syscall
		b end_if_m_b
	else_m_8_b:
		bne $t9, 8, else_m_9_b
		li $v0, 4
		la $a0, morse8
		syscall
		b end_if_m_b
	else_m_9_b:
		li $v0, 4
		la $a0, morse9
		syscall
		b end_if_m_b
	end_if_m_b:
	
	li $v0, 4                                          #switch line
	la $a0, nextLine
	syscall
	li $v0, 4
	la $a0, nextLine
	syscall
	
	li $v0, 10                                         #exit program
	syscall


