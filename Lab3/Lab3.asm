####################################################################
# Created by:  Shen, Jinghao
#              jshen30	
#	       9 November 2018
#
# Assignment:  Lab 3: Looping in MIPS
#	       CMPE 012, Computer Systems and Assembly Language
#	       UC Santa Cruz, Fall 2018
# Description: This program iterates through a set of numbers and 
#              prints either "Flux," "Bunny," or "Flux Bunny."
#
# Notes:       This program is intended to be run from the MARS IDE		
####################################################################

# REGISTER USAGE
#$t0: User input
#$t1: initialize
#$t2: 5
#$t3: 7
#$t4: loop controller
#$t5: if $t1 mod 5 = 0 then set $t5 to 1
#$t6: if $t1 mod 7 = 0 then set $t6 to 1
#$t7: check if $t5 and $t6 are both 1

.text
main:
	li $v0, 4                            #ask for a number
	la $a0, prompt
	syscall
 	
 	li $v0, 5                            #save the number
 	syscall
 	move $t0, $v0			
 	
 	addi $t1, $zero, 0                   #initialize
 	addi $t2, $zero, 5           		
 	addi $t3, $zero, 7           
 	
 	start_loop:
 		sle $t4, $t1, $t0            #loop if $t1<$t0
 		beqz $t4, end_loop
 		
 		div $t1, $t2                 #check if $t1 mod 5 = 0
 		mfhi $t5  		
 		seq $t5, $t5, 0
 		div $t1, $t3                 #check if $t1 mod 7 = 0
 		mfhi $t6	
 		seq $t6, $t6, 0	
 		
 		#if block
 			and $t7, $t5, $t6    #check if it can be divided by both 5 and 7
 			beqz $t7, flx
 			li $v0, 4
 			la $a0, fluxBunny
 			syscall
 			b end_if
 		flx:                         #check if it can be divided by 5
 			beqz $t5, bny        
 			li $v0, 4
 			la $a0, flux
 			syscall
 			b end_if
 		bny:                         #check if it can be divided by 7
 			beqz $t6, else       
 			li $v0, 4
 			la $a0, bunny
 			syscall
 			b end_if
 		else:                        #print out the number if neither satisfied 
 			li $v0, 1
 			add $a0, $t1, $zero
 			syscall
 			li $v0, 4
 			la $a0, Nline        #change the line after print out the number   
 			syscall
 			b end_if
 		end_if:
 		
 		addi $t1, $t1, 1
 		b start_loop
 	end_loop:
 	
 	li $v0, 10                          #exit program
 	syscall
 .data
prompt: .asciiz "Please input a positive integer: "
flux: .asciiz "Flux\n"
bunny: .asciiz "Bunny\n"
fluxBunny: .asciiz "Flux Bunny\n"
Nline: .asciiz "\n"

