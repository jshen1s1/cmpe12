############################################################################
# Created by:  Shen, Jinghao
#              jshen30
#              7 Dec 2018
#
# Assignment:  Lab 5: Subroutines
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program will display a string and prompt the user to 
#              type the same string in agiven time limit. 
#              It will check if this string is identical to the given one 
#              andwhether the user made the time limit. 
#              If the user types in the prompt incorrectly ordoes not 
#              finish the prompt in the given time limit, the game is over.
#
# Notes:       This program is intended to be run from the MARS IDE.
############################################################################

# Registers usage
# $s1: str length counter 
# $a0: input
# $a1: input
# $a2: input


.data
promts: .asciiz "Type Promt: "
userInput: .space 60
	
	
.text
give_type_prompt:
	subi $sp, $sp, 4                                      #store the $ra into stack
	sw $ra, ($sp)
	
	move $t0, $a0                                         #get the address of type prompt to be printed to user
	
	li $v0, 4                                             #print promt everytime
	la $a0, promts
	syscall 
	
	li $v0, 4                                             #print wordset
	move $a0, $t0
	syscall
	
	li $v0, 30                                            #get current time 
	syscall
	move $t0, $a0
	
	li $v0, 8                                             #read user input
	la $a0, userInput
	li $a1, 60
	syscall
	
	move $v0, $t0
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra                                                #return to $ra
	 
	
check_user_input_string:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	move $t3, $a0                                         #store the address of type prompt printed to user in $t3
	add $t0, $a1, $a2                                     #get the supposed time in $t0
	li $v0, 30
	syscall
	move $t1, $a0                                         #get the current time
		bgt $t1, $t0, fail_i                          #if current time is greater than supposed time - fail
		move $a0, $t3
		la $a1, userInput
		jal compare_strings
		b exit_i
	fail_i:
		addi $v0, $zero, 0                            #return 0 if fail
	exit_i:
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
compare_strings:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	move $t7, $a0                                         #store the address in $t7 and $t8
	move $t8, $a1
	
	addi $t0, $zero, 0                                    #check the length of string 1 (wordset)
	stl1:
		lb $t1, ($t7)
		beq $t1, 0x0a, exit_loop1
		loop_check_punc_1:
				slti $t3, $t1, 0x41            #ignore punctuation
				sne $t4, $t1, 0x20             #don't ignore space 
				and $t5, $t3, $t4
				bnez $t5, punctuation_1
				b not_punc_1
			punctuation_1:
				addi $t7, $t7, 1               #read the next char  
				lb $t1, ($t7)
				b loop_check_punc_1
		not_punc_1:
		addi $t7, $t7, 1
		addi $t0, $t0, 1                              #add 1 for each non-punctuation char
		b stl1
	exit_loop1:
	
	addi $t1, $zero, 0                                    #check the length of string 2 (userinput)
	stl2:
		lb $t2, ($t8)
		beq $t2, 0x0a, exit_loop2
		loop_check_punc_2:
				slti $t3, $t2, 0x41           #ignore punctuation
				sne $t4, $t2, 0x20            #don't ignore space 
				and $t5, $t3, $t4
				bnez $t5, punctuation_2
				b not_punc_2
			punctuation_2:
				addi $t8, $t8, 1              #read the next char  
				lb $t2, ($t8)
				b loop_check_punc_2
		not_punc_2:		
		addi $t8, $t8, 1
		addi $t1, $t1, 1
		b stl2
	exit_loop2:

	move $t7, $a0                                        #store the address in $t7 and $t8
	move $t8, $a1
	
		bne $t0, $t1, fail_s                         #if the length not equal - fail
		loop_check_char:                             #else check each char
			beqz $s1, exit_compare_string
			lb $a0, ($t7)                         #get the char from string 1 (wordset)
			loop_check_punc_11:
				slti $t3, $a0, 0x41           #ignore punctuation
				sne $t4, $a0, 0x20            #don't ignore space 
				and $t5, $t3, $t4
				bnez $t5, punctuation_11
				b not_punc_11
			punctuation_11:
				addi $t7, $t7, 1              #read the next char  
				lb $a0, ($t7)
				b loop_check_punc_11
			not_punc_11:
			lb $a1, ($t8)                        #get the char from string 2 (user input)
			loop_check_punc_22:
				slti $t3, $a1, 0x41
				sne $t4, $a1, 0x20 
				and $t5, $t3, $t4
				bnez $t5, punctuation_22
				b not_punc_22
			punctuation_22:
				addi $t8, $t8, 1             #read the next char  
				lb $a1, ($t8)
				b loop_check_punc_22
			not_punc_22:
			jal compare_chars   
			beq $v0, 0, exit_compare_string     #return 0 if any char test fail
				subi $s1, $s1 1
				addi $t7, $t7, 1
				addi $t8, $t8, 1
				b loop_check_char
	fail_s:
		addi $v0, $zero, 0
	exit_compare_string:
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

compare_chars:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	move $t0, $a0                                        #store first char in $t0
	move $t1, $a1                                        #store secind char in $t1
	
	add $t3, $t0, 0x20
	seq $t4, $t1, $t0
	seq $t5, $t1, $t3
		or $t6, $t4, $t5                             #check if $t1 = $t3 ignoring cap
		beqz $t6, fail_c
		addi $v0, $zero, 1                           #return 1 if eql
		b exit_check_c
	fail_c:
		addi $v0, $zero, 0
	exit_check_c:
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
