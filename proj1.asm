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
pickChoice: .asciiz "Select an option: " 

inputFile: .asciiz "medical_records.txt"
inputBuffer: .space 1024

enteredS: .asciiz "\nPARSING STARTED\n"
convertingS: .asciiz "\nConversing STARTED\n"

.align 2
patient_info: .space 120       # Array to store patients information 

testName: .space 8
testDate: .space 8
testRes: .space 8


temp: .asciiz "temp\ttemp\ttemp\n"
temp1: .asciiz "\n=============================\n"
split:.asciiz "|"
temp2: .asciiz "\n-----------------------------------\n"
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


# START PARSING 
# t1 => ID , $t9 => name.address, $t8 => date.address, $t7 => result.address
la $t9, testName
la $t8, testDate
la $t7, testRes
la $t0, inputBuffer      # Load address of buffer into $t0
li $t1, 0           # Initialize register for address
la $t4, patient_info        # Load base address of patient information
j parse_ID



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
# Parse the line
    
parse_ID:
    lb $t2, 0($t0)      # Load byte from buffer into $t2
    beq $t2, ':', found_ID_end  # If colon (':') is found, exit loop
    sub $t2, $t2, '0'   # Convert ASCII to integer
    mul $t1, $t1, 10    # Multiply address by 10
    add $t1, $t1, $t2   # Add digit to address
    addi $t0, $t0, 1    # Move to next character in buffer
    j parse_ID     # Repeat until colon is found

found_ID_end:
	addi $t0, $t0, 2    # Move past colon and space
	
	#lw $t3, patient_count            # Load number of patients
	#mul $t3, $t3, 4                  # Calculate offset for the new patient
	#add $t4, $t4, $t3                # Calculate address for the new patient
	
	move $a0,$t1
	sw $a0, 0($t4)                    # Store patient ID
	
	la $a0, temp2
	li $v0, 4 # Print String
	syscall
	
	#print id
	lw $t5, ($t4)  
	move $a0, $t5  
	li $v0, 1       
	syscall     
	
	j parse_Name
    
parse_Name:
	lb $t2, 0($t0)      # Load byte from buffer into $t2
	beq $t2, ',', found_name_end  # If comma (',') is found, exit loop
	sb $t2, 0($t9)
	addi $t9, $t9, 1
	addi $t0, $t0, 1
	j parse_Name
          
found_name_end:
	addi $t0, $t0, 2    # Move past comma and space
	
	# Store name address
	la $a0, testName
	sw $a0, 4($t4)                   # Store name address (4 bytes offset from patient ID)
	
	#li $a0,0
	#sw $a0, testName
	la $t9, testName
	
	la $a0, split
	li $v0, 4 # Print String
	syscall
	
	# Load name address into $a0
	lw $a0, 4($t4)                   # Load the address of testName from memory into $a0
	# Load the string from the address
	li $v0, 4                        # Print string syscall
	syscall
	
	
	j parse_Date
    
parse_Date:
	lb $t2, 0($t0)      # Load byte from buffer into $t2
	beq $t2, ',', found_Date_end  # If comma (',') is found, exit loop
	sb $t2, 0($t8)
	addi $t8, $t8, 1
	addi $t0, $t0, 1
	j parse_Date
      
found_Date_end:
	addi $t0, $t0, 2    # Move past comma and space
	#Store date address
	la $a0, testDate                    # load date address to $a0
	sw $a0, 8($t4)                   # Store date address (8 bytes offset from patient ID)
	
	li $a0,0
	la $t8, testDate
	
	la $a0, split
	li $v0, 4 # Print String
	syscall
	
	# Load date address into $a0
	lw $a0, 8($t4)                   # Load the address of testName from memory into $a0

	# Load the string from the address
	li $v0, 4                        # Print string syscall
	syscall
	
	
	j parse_Res
	
    
parse_Res:
	lb $t2, 0($t0)      # Load byte from buffer into $t2

	
	beq $t2, $zero, found_Res_end # If end of file
	beq $t2, '\n',found_Res_end   # If new Line
	sb $t2, 0($t7)
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	j parse_Res
		
found_Res_end:

	#Store date address
	la $a0, testRes                    # load date address to $a0
	sw $a0, 12($t4)                   # Store date address (8 bytes offset from patient ID)
	
	li $a0,0
	la $t7, testRes
	
	la $a0, split
	li $v0, 4 # Print String
	syscall
	
	# Load date address into $a0
	lw $a0, 12($t4)                   # Load the address of testName from memory into $a0

	# Load the string from the address
	li $v0, 4                        # Print string syscall
	syscall
	
	beq $t2, $zero, EXIT # If end of file
	beq $t2, '\n',newLine  # If new Line
	
	
newLine:
	addi $t4,$t4,16
	addi $t0, $t0, 1    # Move past new Line
	li $t1, 0 # i did this just to check and this to reset ID again
	j parse_ID
            
EXIT:
	la $t4, patient_info             # Load base address of patient information
	lw $a0, 4($t4)                   # Load the address of testName from memory into $a0
	li $v0, 4                       # Print string syscall
	syscall
	
	li $v0, 10 # Exit program
	syscall