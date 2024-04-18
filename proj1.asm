# Title: Medical Test Management System			 	Filename: project1.asm
# Author: Sami Moqbel 1200751 - Lama Abdelmohsen 1201138	Date: 14/4/2024
# Description:
# Input:
# Output:
################# Data segment #####################
.data
menu: .asciiz "\nMedical Test Management System Menu:\n"
firstChoice: .asciiz "1- Add a new medical test\n"
secondChoice: .asciiz "2- Search for a test by patient ID\n"
thirdChoice: .asciiz "3- Search for unnormal tests\n"
fourthChoice: .asciiz "4- Print Average test value\n"
fivthChoice: .asciiz "5- Update an existing test result\n"
sixthChoice: .asciiz "6- Delete a test\n"
seventhChoice: .asciiz "7- Exit!\n"

enteredS: .asciiz "\nPARSING STARTED\n"
convertingS: .asciiz "\nConversing STARTED\n"

pickChoice: .asciiz "Select an option: " 

inputFile: .asciiz "medical_records.txt"
inputBuffer: .space 1024


temp: .asciiz "temp\ttemp\ttemp\n"
temp1: .asciiz "\n=============================\n"
#. . .
################# Code segment #####################
.text
.globl main
main: # main program entry

la $a0, inputFile #Load File Name Address
li $a1, 0 # Set Read-Only Mode
li $a2, 0 #ignored
li $v0, 13 # syscall for open file
syscall

move $s0, $v0 # save file descriptor in saved-temp

move $a0, $s0
la $a1, inputBuffer
li $a2, 1024 # hardcoded buffer length
li $v0, 14 # syscall for reading from file
syscall


#Test Output
la	$a0, inputBuffer
li	$v0, 4
syscall

la $t0, inputBuffer     # Pointer to the beginning of the buffer
la $t1, inputBuffer    # Pointer to iterate through the buffer

j parse_loop



MENU:
la $a0, menu
li $v0, 4 # Print String
syscall

la $a0, firstChoice
li $v0, 4 # Print String
syscall

la $a0, secondChoice
li $v0, 4 # Print String
syscall

la $a0, thirdChoice
li $v0, 4 # Print String
syscall

la $a0, fourthChoice
li $v0, 4 # Print String
syscall

la $a0, fivthChoice
li $v0, 4 # Print String
syscall

la $a0, sixthChoice
li $v0, 4 # Print String
syscall

la $a0, seventhChoice
li $v0, 4 # Print String
syscall

la $a0, pickChoice
li $v0, 4 # Print String
syscall

li $v0, 5 # Read Integer
syscall

move $t0, $v0 # t0 = Choice

#move $a0, $t0
#li $v0, 1 # Print Integer
#syscall

beq $t0, 1, ADD
beq $t0, 2, SEARCH_ID
beq $t0, 3, SEARCH_T
beq $t0, 4, PRINT
beq $t0, 5, UPDATE
beq $t0, 6, DELETE
beq $t0, 7, EXIT
j MENU


ADD: #add new test
la $a0, temp
li $v0, 4 # Print String
syscall
j MENU

UPDATE:
la $a0, temp1
li $v0, 4 # Print String
syscall
j MENU

DELETE:
la $a0, temp1
li $v0, 4 # Print String
syscall
j MENU

PRINT:
la $a0, temp1
li $v0, 4 # Print String
syscall
j MENU

SEARCH_ID:
la $a0, temp1
li $v0, 4 # Print String
syscall
j MENU

SEARCH_T:
la $a0, temp1
li $v0, 4 # Print String
syscall
j MENU

#############################
parse_loop:
    # Load a byte from the buffer
    lb $t2, 0($t1)
    
    # Check if the current character is a newline or we reached the end of the buffer
    
    # beq $t2, '\n', end_parse   # End parsing if newline character is found
    # beq $t0, $a2, EXIT    # End parsing if end of buffer is reached
    sub $t2, $t2, 0 
    # Check if the current character is a colon (':'), indicating the start of patientId
    
    #la $a0, temp1
    #li $v0, 4 # Print String
    #syscall
    
    #li $v0, 11         # syscall code for printing a character
    #move $a0, $t2      # load $t2 into argument register $a0
    #syscall            # print the content of $t2 as a character
    
    beq $t2, ':', parse_patientId
    
    # Move to the next character in the buffer
    addi $t1, $t1, 1
    j parse_loop


parse_patientId:
    # Process patientId here
    
    la $a0, enteredS
    li $v0, 4 # Print String
    syscall
    
    li $t3, 0          # Initialize patientId to 0
    move $t4, $t0 ## SHOULD BE MODIFIED
    
    loop_patientId:
        lb $t5, 0($t4)  # Load a byte from the buffer
        
        la $a0, temp1
    	li $v0, 4 # Print String
    	syscall
    
   	li $v0, 11         # syscall code for printing a character
    	move $a0, $t2      # load $t2 into argument register $a0
   	syscall            # print the content of $t2 as a character
        
        la $a0, convertingS
    	li $v0, 4 # Print String
    	syscall
    	
    	beq $t5, ':', EXIT
        
        # Convert character to integer and update patientId
        sub $t5, $t5, 0   # Convert ASCII to integer
        mul $t3, $t3, 10    # Shift current patientId to the left by one digit
        add $t3, $t3, $t5   # Add current digit to patientId
        
        # Move to the next character in the buffer
        addi $t5, $t5, 1
        j loop_patientId
        
        
PRINTID:

	la $a0, temp1
	li $v0, 4 # Print String
	syscall
	
	move $a0, $t3
	li $v0, 1 # Print Integer
	syscall
        
EXIT:
li $v0, 10 # Exit program
syscall
