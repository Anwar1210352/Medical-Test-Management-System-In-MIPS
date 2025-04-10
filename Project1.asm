#Title: Medical Test Management System
#Authors: Yaman abu jazar & Anwar jaber
######################################################################## Data segment ########################################################################
.data
WelcomeMsg: .asciiz "*********************************************************************************************************************************************************************\n\t\t\t\t\t\t\tWelcome to Medical Test Management System.\n*********************************************************************************************************************************************************************\n"
Menu: .asciiz "\nMenu\n1-Add new medical test.\n2-Search for a test by patient ID.\n3-Search for unnormal tests.\n4-Average test value.\n5-Update an existing test result.\n6-Delete a test.\n7-Exit the program.\nChoose one from the following choices : "
selection: .half 0
buffer: .space 5000	# buffer to store the data of the file
FileName: .space 50
EnterFileNameMsg: .asciiz "Enter name of the input file : "
FileDescriptor: .word 4	# variable to store the file descriptor
ErrorMsgOF: .asciiz "Error Opening File\nTry again...\n"	# message for error opening the file
IDArray: .align 2 
.space 20000	# allocate 50 indices for patient's ID
TnameArray: .align 2 
.space 20000	# allocate 50 indices for test name
TdateArray: .align 3 
.space 20000	# allocate 50 indices for test date
TresultArray: .align 3
.float 0.0:20000	# allocate 50 indices for test result
newLine: .asciiz "\n"
lineBuffer: .align 2 
.space 20
tempDate: .align 3 
.space 20
tempResult: .align 3 
.space 20
index: .word 0
indexofTname: .word 0
indexofTdate: .word 0
indexofTresult: .word 0
intPartofresult: .align 2
.space 10
fractionPartofresult: .align 2 
.space 10
ten: .float 10.0
PIDmsg1: .asciiz "Enter the Patient ID (consist of 7 digits) : "
TnameMsg1: .asciiz "Enter the name of the medical test (Hgb, BGT, LDL, or BPT) : "
TdateMsg1: .asciiz "Enter the date of the medical test (YYYY-MM) : "
TresultMsg1: .asciiz "Enter the result of the medical test : "
ErMsgID: .asciiz "Invalid ID number try again...\n"
ErrorMsgTname: .asciiz "Invalid medical test name..\nchoose one medical test name from the following\nHgb, BGT, LDL, or BPT.\n"
validName1: .asciiz "Hgb"
validName2: .asciiz "BGT"
validName3: .asciiz "LDL"
validName4: .asciiz "BPT"
currentYear: .word 2024      # Assume current year is 2024
currentMonth: .word 4        # Assume current month is April (04)
dateErrorMsg: .asciiz "Invalid date format or date is in the future.\n"
SBPTresultMsg1: .asciiz "Enter the result of Systolic Blood Pressure : "
DBPTresultMsg1: .asciiz "Enter the result of Diastolic Blood Pressure : "
AddingSuccess: .asciiz "\nThe Medical Test Has Been Added.\n"
menuSelection2: .asciiz "\nWhat are you searching for:\n1-Retrieve all patient tests.\n2-Retrieve all up normal patient tests.\n3-Retrieve all patient tests in a given specific period.\nChoose one from the above choices : "
ReadingIDMsg2: .asciiz "Enter the Patient's ID (7 digits) : "
IDnotExist: .asciiz "\nThe ID does not exist in the management system\nTry again...\n"
IDMP: .asciiz "\nPatient ID : "
TNMP: .asciiz "\nMedical Test Name : "
TDMP: .asciiz "\nMedical Test Date : "
TRMP: .asciiz "\nMedical Test Result : "
ForwardSlash: .asciiz "/"
beginningPeriod: .align 3
.space 20
endingPeriod: .align 3
.space 20
date1Msg2: .asciiz "\nRequired medical tests from date : "
date2Msg2: .asciiz "\nInto date : "
BeginningdateErrorMsg: .asciiz "Invalid date format or date is in the future\nTry again....\n"
EndingdateErrorMsg: .asciiz "Invalid date format\nTry again....\n"
EndingdateErrorMsg2: .asciiz "Invalid Period, the End date before Beginning date...\nEnter the Period correctly.\n"
MeasuringUnitHgb: .asciiz " g/dL"
MeasuringUnitBGTandLDL: .asciiz " mg/dL"
MeasuringUnitBPT: .asciiz " mm Hg"
RangeofHgb: .align 2
.float 13.8, 17.2
RangeofBGT: .align 2
.float 70.0, 99.0
RangeofLDL: .align 2
.float 100.0
RangeofBPT: .align 2
.float 120.0, 80.0
MedicalTestNameMenu: .asciiz "1-Hemoglobin (Hgb).\n2-Blood Glucose Test (BGT).\n3-LDL Cholesterol Low-Density Lipoprotein (LDL).\n4-Blood Pressure Test (BPT).\nChoose the medical test : "
ErrorSelection: .asciiz "Invalid Choice.\nTry again.\n"
AverageHgbMsg: .asciiz "\nThe Average value of Hgb medical test = "
AverageBGTMsg: .asciiz "\nThe Average value of BGT medical test = "
AverageLDLMsg: .asciiz "\nThe Average value of LDL medical test = "
AverageBPTMsg: .asciiz "\nThe Average value of BPT medical test = "
CheckUpdate: .asciiz "\nIs this test you want to update??\n1-Yes.\n2-No.\nIf yes choose 1 if no choose 2 : "
NewResultMsg: .asciiz "Enter the result : "
NewResultMsgSBP: .asciiz "Enter the result of Systolic Blood Pressure : "
NewResultMsgDBP: .asciiz "Enter the result of Diastolic Blood Pressure : "
ResultUpdated: .asciiz "The result has been updated.\n"
CheckDelete: .asciiz "\nIs this test you want to delete??\n1-Yes.\n2-No.\nIf yes choose 1 if no choose 2 : "
TestDeleted: .asciiz "The result has been deleted.\n"
EndOfTests: .asciiz "That were all medical tests the patient did.\n" 
ExittingProgram: .asciiz "\nThank you for using our Medical Test Management System.\nExitting Program...\n"
OutputFileName: .asciiz "Output.txt"
OutputBuffer: .space 5000
outputID: .align 2
.space 20
outputResult: .align 3
.space 20
######################################################################## Code segment ########################################################################
.text
.globl main
main:
# print the welcome message
	la $a0, WelcomeMsg	# $a0 = address of welcome message
	li $v0, 4	# print the welcome message
	syscall
# ask the user for the input file data
ReadingFileName:
	la $a0, EnterFileNameMsg
	li $v0, 4
	syscall
	la $a0, FileName
	li $a1, 25
	li $v0, 8
	syscall
reachNull:
	lb $t0, 0($a0)
	beq $t0, 10, removeNull
	addi $a0, $a0, 1
	j reachNull
removeNull:
	li $t0, 0
	sb $t0, 0($a0)	
# Opening the input file	
	la $a0, FileName	# $a0 = address of FileName
	li $a1, 0	# read-only mode
	li $v0, 13	# open the file
	syscall
	
	bgez $v0, ReadFile
	la $a0, ErrorMsgOF	# $a0 = address of ErrorMsgOF
	li $v0, 4	# print Error message
	syscall
	
	j ReadingFileName

# Reading from input file
ReadFile:
	sw $v0, FileDescriptor
	lw $a0, FileDescriptor	# $a0 = File descriptor
	la $a1, buffer	# $a1 = address of input buffer
	la $a2, 5000	# $a2 = maximum number of charachters to read
	li $v0, 14
	syscall
	
# Closing the input file
	lw $a0, FileDescriptor        # Load the file descriptor again
	li $v0, 16                    # Syscall to close a file
	syscall
####################################### Splitting the input Buffer into arrays ##########################################
parseBuffer:
	la $a0, buffer
parse_line:
    	# Check if the buffer's end has been reached
    	lb $t0, 0($a0)           # Load the first byte of the line
    	beqz $t0, menu           # If it's zero, we've reached the end of the buffer

    	# Parse ID
    	la $t1, lineBuffer       
    	li $t2, 0
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
# split the ID from the input buffer then store it in array
parse_id:
    	lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 58, store_id    # ASCII 58 is ':'
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_id
    	
store_id:
	la $t3, lineBuffer
	li $t4, 0
convertIntoInt:	
	lb $t5, 0($t3)
	beqz $t5, doneAndStoreID
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertIntoInt
MakePositive:
	addi $t4, $t4, 380000000
	j storeID
doneAndStoreID: 
	la $t7, IDArray             # Load the base address of IDArray
    	lw $t8, index               # Load the current index
    	sll $t8, $t8, 2             # Calculate the correct offset (index * 4 bytes)
    	add $t7, $t7, $t8           # Calculate the correct address to store the ID
    	bltz $t4, MakePositive
storeID:
    	sw $t4, 0($t7)              # Store the ID in the array at the correct offset
    	addiu $t8, $t8, 1           # Increment the index
    	sw $t8, index 

	# Parse Test name
	addiu $a0, $a0, 1       # Move to next character
	addiu $a0, $a0, 1	# Move to next character(Skip space)
	# Clearing the Line Buffer
    	la $t1, lineBuffer 
    	li $t2, 0      
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
    	sw $t2, 16($t1)
# split the test name from the input buffer then store it in array   
parse_testName:
        lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 44, store_testName    # ASCII 44 is ','
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_testName
    	
store_testName:
	la $t1, lineBuffer
	la $t3, TnameArray
	lw $t4, 0($t1)
	lw $t5, indexofTname
	sll $t5, $t5, 2
	add $t3, $t3, $t5
	sw $t4, 0($t3)
	addiu $t5, $t5, 1
	sw $t5, indexofTname
	
	
	# Parse Test date
	addiu $a0, $a0, 2 # skip the comma and the space
	la $t1, tempDate  
	li $t2, 0     
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
    	
# split the test date from the input buffer then store it in array    	
parse_testdate:
        lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 44, store_testdate    # ASCII 44 is ','
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_testdate
    	
store_testdate:
	la $t1, tempDate
	la $t3, TdateArray
	lw $t4, 0($t1)
	lw $t6, 4($t1)
	lw $t5, indexofTdate
	sll $t5, $t5, 3
	add $t3, $t3, $t5
	sw $t4, 0($t3)
	sw $t6, 4($t3)
	addiu $t5, $t5, 1
	sw $t5, indexofTdate
	
	la $t8, lineBuffer             # Address of the input buffer
    	la $t9, validName4             # First valid test name
    	jal string_compare1             # Call the string comparison function
    	beq $v0, 1, StoreTwoResults 
    	j parse_testresult
    	
string_compare1:
    	move $t2, $t8                  # Pointer to first string
    	move $t3, $t9                  # Pointer to second string

compare_loop1:
    	lb $t6, 0($t2)                 # Load byte from first string
    	lb $t5, 0($t3)                 # Load byte from second string
    	beqz $t5, compare_success1      # If we reach '\0', strings are equal
    	beqz $t6, compare_success1 
    	beq $t6, 10, compare_success1
    	beq $t1, 10, compare_success1
    	bne $t6, $t5, compare_fail1     # If bytes are not equal, fail
    	addiu $t2, $t2, 1              # Increment pointer
    	addiu $t3, $t3, 1              # Increment pointer
    	j compare_loop1                 # Loop back

compare_fail1:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success1:
    	li $v0, 1                      # Set return value to 1
    	jr $ra                         # Return
	
    	
	
# split the test result from the input buffer then store it in array    	
parse_testresult:
	# Parse Test result
	addiu $a0, $a0, 2 # skip the comma and the space
	la $t1, tempResult 
	li $t2, 0      
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
parse_testresult1:
        lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 10, store_testresult    # ASCII 10 is '\n'
    	beq $t3, 0, store_testresult    # ASCII 0 is '\0' (End of File)
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_testresult1
    	
store_testresult:
	la $t1, tempResult
	la $t3, intPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_IntPart:
	lb $t5, 0($t1)
	beqz $t5, convert_IntPartWithoutFP # branch if we reached '.' or '\0' 
	beq $t5, 10, convert_IntPartWithoutFP
	beq $t5, 13, convert_IntPartWithoutFP
	beq $t5, 46, convert_IntPart
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_IntPart

convert_IntPartWithoutFP:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt2:
	lb $t5, 0($t3)
	beqz $t5, finishIntPart1
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt2
	
finishIntPart1:
	la $t1, TresultArray
	lw $t3, indexofTresult
	sll $t3, $t3, 3
	add $t1, $t1, $t3
	mtc1 $t4, $f0
	cvt.s.w $f0, $f0
	swc1 $f0, 0($t1)
	addiu $t3, $t3, 1
	sw $t3, indexofTresult
	
	la $t1, lineBuffer
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	
	addiu $a0, $a0, 1
	j parse_line 	
    	
convert_IntPart:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt:
	lb $t5, 0($t3)
	beqz $t5, finishIntPart
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt

finishIntPart:
	addiu $t1, $t1, 1        # Move to next character(fraction part)
	la $t3, fractionPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_fractionPart:
	lb $t5, 0($t1)
	beqz $t5, convert_FractionPart
	beq $t5, 10, convert_FractionPart
	beq $t5, 13, convert_FractionPart
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_fractionPart

convert_FractionPart:
	la $t3, fractionPartofresult
	li $t5, 0	# storing fraction part in $t5
convertFraction:
	lb $t6, 0($t3)
	beqz $t6, finishFractionPart
	subi $t6, $t6, '0'
	
	li $t7, 10
	mul $t5, $t5, $t7
	
	add $t5, $t5, $t6
	
	addiu $t3, $t3, 1
	j convertFraction  
	
finishFractionPart:
	# $t4 has the integer part and $t5 has the fraction part
	# here we want to combine them 	
	la $t1, fractionPartofresult
	li $t6, 0	# store number of digits in fraction part
determineDecimalCount: 
	lb $t3, 0($t1)
	beqz $t3, combine
	beq $t3, 10, combine
	addiu $t6, $t6, 1
	addiu $t1, $t1, 1
	j determineDecimalCount
			 	   	    	    		 	   	    	    			 	   	    	    		 	   	    	    	
combine:
	# Convert integer part $t4 to floating-point and store in $f0
    	mtc1 $t4, $f0                # Move from GPR to FPR
    	cvt.s.w $f0, $f0             # Convert word to single precision float
	
    	# Convert fractional part $t5 to floating-point and store in $f1
    	mtc1 $t5, $f1                # Move from GPR to FPR
    	cvt.s.w $f1, $f1             # Convert word to single precision float

    	# Load the constant '10.0' into $f2 for division
    	la $s0, ten
    	lwc1 $f2, 0($s0)

    	# Prepare to scale the fractional part by the appropriate power of 10
    	li $t7, 1                    # Start with scale factor of 1 in $f3
    	mtc1 $t7, $f3
    	cvt.s.w $f3, $f3

scale_loop:
    	blez $t6, scale_done         # If $t6 is 0, we are done scaling
    	mul.s $f3, $f3, $f2          # Multiply scale factor by 10
    	subi $t6, $t6, 1            # Decrement decimal count
    	j scale_loop                 # Repeat scaling

scale_done:
    	div.s $f1, $f1, $f3          # Divide fractional part by scale factor
	
    	# Add integer part and fractional part
    	add.s $f0, $f0, $f1          # $f0 = integer part + fractional part
	
	la $t1, TresultArray
	lw $t3, indexofTresult
	sll $t3, $t3, 3
	add $t1, $t1, $t3
	swc1 $f0, 0($t1)
	addiu $t3, $t3, 1
	sw $t3, indexofTresult 
	
	la $t1, lineBuffer
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	
	addiu $a0, $a0, 1
	j parse_line
	    	      	    	    		    	      	    	    	
########################################## if Test Name is BGT then there is two results #########################################	    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    	
StoreTwoResults:
###################################### Convert the result of SBP ################################ 
	# Parse Test result SBP
	addiu $a0, $a0, 2 # skip the comma and the space
	la $t1, tempResult 
	li $t2, 0      
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
parse_testresultSBP:
        lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 47, store_testresultSBP    # ASCII 47 is '/'
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_testresultSBP
    	
store_testresultSBP:
	la $t1, tempResult
	la $t3, intPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_IntPartSBP:
	lb $t5, 0($t1)
	beqz $t5, convert_IntPartWithoutFPSBP # branch if we reached '\r' or '\0' or '\n' 
	beq $t5, 10, convert_IntPartWithoutFPSBP
	beq $t5, 13, convert_IntPartWithoutFPSBP
	beq $t5, 46, convert_IntPartSBP
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_IntPartSBP

convert_IntPartWithoutFPSBP:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt1SBP:
	lb $t5, 0($t3)
	beqz $t5, finishIntPartSBP
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt1SBP
	
finishIntPartSBP:
	mtc1 $t4, $f0
	cvt.s.w $f0, $f0
	########################### $f0 has the result of SBP
	
	j parse_testresultDBP1	
    	
convert_IntPartSBP:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt2SBP:
	lb $t5, 0($t3)
	beqz $t5, finishIntPartSBP1
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt2SBP

finishIntPartSBP1:
	addiu $t1, $t1, 1        # Move to next character(fraction part)
	la $t3, fractionPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_fractionPartSBP:
	lb $t5, 0($t1)
	beqz $t5, convert_FractionPartSBP
	beq $t5, 10, convert_FractionPartSBP
	beq $t5, 13, convert_FractionPartSBP
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_fractionPartSBP

convert_FractionPartSBP:
	la $t3, fractionPartofresult
	li $t5, 0	# storing fraction part in $t5
convertFractionSBP:
	lb $t6, 0($t3)
	beqz $t6, finishFractionPartSBP
	subi $t6, $t6, '0'
	
	li $t7, 10
	mul $t5, $t5, $t7
	
	add $t5, $t5, $t6
	
	addiu $t3, $t3, 1
	j convertFractionSBP  
	
finishFractionPartSBP:
	# $t4 has the integer part and $t5 has the fraction part
	# here we want to combine them 	
	la $t1, fractionPartofresult
	li $t6, 0	# store number of digits in fraction part
determineDecimalCountSBP: 
	lb $t3, 0($t1)
	beqz $t3, combineSBP
	beq $t3, 10, combineSBP
	addiu $t6, $t6, 1
	addiu $t1, $t1, 1
	j determineDecimalCountSBP
			 	   	    	    		 	   	    	    			 	   	    	    		 	   	    	    	
combineSBP:
	# Convert integer part $t4 to floating-point and store in $f0
    	mtc1 $t4, $f0                # Move from GPR to FPR
    	cvt.s.w $f0, $f0             # Convert word to single precision float
	
    	# Convert fractional part $t5 to floating-point and store in $f1
    	mtc1 $t5, $f1                # Move from GPR to FPR
    	cvt.s.w $f1, $f1             # Convert word to single precision float

    	# Load the constant '10.0' into $f2 for division
    	la $s0, ten
    	lwc1 $f2, 0($s0)

    	# Prepare to scale the fractional part by the appropriate power of 10
    	li $t7, 1                    # Start with scale factor of 1 in $f3
    	mtc1 $t7, $f3
    	cvt.s.w $f3, $f3

scale_loopSBP:
    	blez $t6, scale_doneSBP         # If $t6 is 0, we are done scaling
    	mul.s $f3, $f3, $f2          # Multiply scale factor by 10
    	subi $t6, $t6, 1            # Decrement decimal count
    	j scale_loopSBP                 # Repeat scaling

scale_doneSBP:
    	div.s $f1, $f1, $f3          # Divide fractional part by scale factor
	
    	# Add integer part and fractional part
    	add.s $f0, $f0, $f1          # $f0 = integer part + fractional part
    	##################################### $f0 has the result of SBP
###################################### Convert the result of DBP ################################    
parse_testresultDBP1:	
    	# Parse Test result DBP
	addiu $a0, $a0, 1 # skip the forward slash 
	la $t1, tempResult 
	li $t2, 0      
    	sw $t2, 0($t1)
    	sw $t2, 4($t1)
    	sw $t2, 8($t1)
parse_testresultDBP:
        lb $t3, 0($a0)           # Load byte from buffer
    	beq $t3, 10, store_testresultDBP    # ASCII 10 is '\n'
    	beq $t3, 13, store_testresultDBP    # ASCII 13 is '\r'
    	beqz $t3, store_testresultDBP    # ASCII 0 is '\0'
    	sb $t3, 0($t1)           # Store byte to lineBuffer
    	addiu $a0, $a0, 1        # Move to next character
    	addiu $t1, $t1, 1        # Increment temporary buffer pointer
    	j parse_testresultDBP
    	
store_testresultDBP:
	la $t1, tempResult
	la $t3, intPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_IntPartDBP:
	lb $t5, 0($t1)
	beqz $t5, convert_IntPartWithoutFPDBP # branch if we reached '\r' or '\0' or '\n' 
	beq $t5, 10, convert_IntPartWithoutFPDBP
	beq $t5, 13, convert_IntPartWithoutFPDBP
	beq $t5, 46, convert_IntPartDBP
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_IntPartDBP

convert_IntPartWithoutFPDBP:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt1DBP:
	lb $t5, 0($t3)
	beqz $t5, finishIntPartDBP
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt1DBP
	
finishIntPartDBP:
	la $t1, TresultArray
	lw $t3, indexofTresult
	sll $t3, $t3, 3
	add $t1, $t1, $t3
	mtc1 $t4, $f1
	cvt.s.w $f1, $f1
	swc1 $f0, 0($t1)
	swc1 $f1, 4($t1)
	addiu $t3, $t3, 1
	sw $t3, indexofTresult
	
	la $t1, lineBuffer
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	
	addiu $a0, $a0, 1
	j parse_line 	
    	
convert_IntPartDBP:
	la $t3, intPartofresult
	li $t4, 0	# storing Int part in $t4
convertInt2DBP:
	lb $t5, 0($t3)
	beqz $t5, finishIntPartDBP1
	subi $t5, $t5, '0'
	
	li $t6, 10
	mul $t4, $t4, $t6
	
	add $t4, $t4, $t5
	
	addiu $t3, $t3, 1
	j convertInt2DBP

finishIntPartDBP1:
	addiu $t1, $t1, 1        # Move to next character(fraction part)
	la $t3, fractionPartofresult
	li $t2, 0
	sw $t2, 0($t3)
	sw $t2, 4($t3)
reach_fractionPartDBP:
	lb $t5, 0($t1)
	beqz $t5, convert_FractionPartDBP
	beq $t5, 10, convert_FractionPartDBP
	beq $t5, 13, convert_FractionPartDBP
	sb $t5, 0($t3)           # Store byte to intPart
    	addiu $t3, $t3, 1
    	addiu $t1, $t1, 1        # Move to next character
    	j reach_fractionPartDBP

convert_FractionPartDBP:
	la $t3, fractionPartofresult
	li $t5, 0	# storing fraction part in $t5
convertFractionDBP:
	lb $t6, 0($t3)
	beqz $t6, finishFractionPartDBP
	subi $t6, $t6, '0'
	
	li $t7, 10
	mul $t5, $t5, $t7
	
	add $t5, $t5, $t6
	
	addiu $t3, $t3, 1
	j convertFractionDBP  
	
finishFractionPartDBP:
	# $t4 has the integer part and $t5 has the fraction part
	# here we want to combine them 	
	la $t1, fractionPartofresult
	li $t6, 0	# store number of digits in fraction part
determineDecimalCountDBP: 
	lb $t3, 0($t1)
	beqz $t3, combineDBP
	beq $t3, 10, combineDBP
	addiu $t6, $t6, 1
	addiu $t1, $t1, 1
	j determineDecimalCountDBP
			 	   	    	    		 	   	    	    			 	   	    	    		 	   	    	    	
combineDBP:
	# Convert integer part $t4 to floating-point and store in $f0
    	mtc1 $t4, $f5                # Move from GPR to FPR
    	cvt.s.w $f5, $f5             # Convert word to single precision float
	
    	# Convert fractional part $t5 to floating-point and store in $f1
    	mtc1 $t5, $f1                # Move from GPR to FPR
    	cvt.s.w $f1, $f1             # Convert word to single precision float

    	# Load the constant '10.0' into $f2 for division
    	la $s0, ten
    	lwc1 $f2, 0($s0)

    	# Prepare to scale the fractional part by the appropriate power of 10
    	li $t7, 1                    # Start with scale factor of 1 in $f3
    	mtc1 $t7, $f3
    	cvt.s.w $f3, $f3

scale_loopDBP:
    	blez $t6, scale_doneDBP         # If $t6 is 0, we are done scaling
    	mul.s $f3, $f3, $f2          # Multiply scale factor by 10
    	subi $t6, $t6, 1            # Decrement decimal count
    	j scale_loopDBP                 # Repeat scaling

scale_doneDBP:
    	div.s $f1, $f1, $f3          # Divide fractional part by scale factor
	
    	# Add integer part and fractional part
    	add.s $f5, $f5, $f1          # $f0 = integer part + fractional part
	
	la $t1, TresultArray
	lw $t3, indexofTresult
	sll $t3, $t3, 3
	add $t1, $t1, $t3
	swc1 $f0, 0($t1)
	swc1 $f5, 4($t1)
	addiu $t3, $t3, 1
	sw $t3, indexofTresult 
	
	la $t1, lineBuffer
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	
	addiu $a0, $a0, 1
	j parse_line    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    		    	      	    	    	
	
######################################################## Print the Main Menu ################################################################	
menu:	
	la $a0, Menu	# $a0 = address of menu
	li $v0, 4	# print the menu
	syscall
	

######################################################### Read the selection of the User #########################################################
	li $v0, 5	# Read the selection
	syscall
	
	move $s0, $v0
	beq $s0, 1, Add_new_medical_test
	beq $s0, 2, Searching_for_test_By_PatientID
	beq $s0, 3, Searching_for_Unnormal_Tests
	beq $s0, 4, AverageTestValue
	beq $s0, 5, UpdateResult
	beq $s0, 6, DeleteTest
	beq $s0, 7, ExitProgram
	
	la $a0, ErrorSelection
	li $v0, 4
	syscall
	j menu
######################################################### Adding new medical test ################################################################	
Add_new_medical_test:
######### Read ID #######
ReadnewID:
	la $a0, PIDmsg1	# Print a message to user to enter the Patient ID
	li $v0, 4
	syscall
	
	la $a0, lineBuffer
	li $a1, 20
	li $v0, 8	# read the ID of the patient
	syscall
	
	j checkPID
	
storeValidID:
	la $a0, lineBuffer
	li $t0, 0
convertIntID:
	lb $t1, 0($a0)
	beqz $t1, storeInarray
	beq $t1, 10, storeInarray
	subi $t1, $t1, '0'
	
	li $t2, 10
	
	mul $t0, $t0, $t2
	
	add $t0, $t0, $t1
	
	addiu $a0, $a0, 1
	j convertIntID

storeInarray:
	la $a0, IDArray
	lw $t1, index
	sll $t1, $t1, 2
	add $a0, $a0, $t1
	sw $t0, 0($a0)
	addi $t1, $t1, 1
	sw $t1, index
	
######## Read Test Name ########
ReadnewTname:
	la $a0, TnameMsg1
	li $v0, 4
	syscall
	
	la $a0, lineBuffer
	li $t0, 0
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	
	la $a0, lineBuffer
	li $a1, 20
	li $v0, 8
	syscall
	
	j checkTname
	
storeValidTname:
	la $a0, lineBuffer
	li $t6, 0
	sb $t6, 3($a0)
	lw $t1, 0($a0)
	la $a1, TnameArray
	lw $t0, indexofTname
	sll $t0, $t0, 2
	add $a1, $a1, $t0
	sw $t1, 0($a1)
	addi $t0, $t0, 1
	sw $t0, indexofTname

######### Read Test date #########
ReadnewTdate:
	la $a0, TdateMsg1
	li $v0, 4
	syscall
	
	la $a0, tempDate
	li $t0, 0
	sw $t0, 0($a0)	# clear the string
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	
	la $a0, tempDate
	li $a1, 20
	li $v0, 8
	syscall
	
	j checkTdate
	
storeValidTdate:
	la $t1, tempDate
	li $t6, 0
	sb $t6, 7($a0)
	la $t3, TdateArray
	lw $t4, 0($t1)
	lw $t6, 4($t1)
	lw $t5, indexofTdate
	sll $t5, $t5, 3
	add $t3, $t3, $t5
	sw $t4, 0($t3)
	sw $t6, 4($t3)
	addiu $t5, $t5, 1
	sw $t5, indexofTdate

########## Check if the Test is BPT or not ###########
	la $a0, lineBuffer             # Address of the input buffer
    	la $a1, validName4             # First valid test name
    	jal string_compare2             # Call the string comparison function
    	beq $v0, 1, ReadTwoNewResults
    	j ReadnewTresultNormal

string_compare2:
    	move $t2, $a0                  # Pointer to first string
    	move $t3, $a1                  # Pointer to second string

compare_loop2:
    	lb $t0, 0($t2)                 # Load byte from first string
    	lb $t1, 0($t3)                 # Load byte from second string
    	beqz $t1, compare_success2      # If we reach '\0', strings are equal
    	beqz $t0, compare_success2 
    	beq $t0, 10, compare_success2
    	beq $t1, 10, compare_success2
    	bne $t0, $t1, compare_fail2     # If bytes are not equal, fail
    	addiu $t2, $t2, 1              # Increment pointer
    	addiu $t3, $t3, 1              # Increment pointer
    	j compare_loop2                 # Loop back

compare_fail2:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success2:
    	li $v0, 1                      # Set return value to 1
    	jr $ra 	
######### Read Test result #########
ReadnewTresultNormal:
	la $a0, TresultMsg1
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
storeResultNormal:
	la $a0, TresultArray
	lw $t1, indexofTresult
	sll $t1, $t1, 3
	add $a0, $a0, $t1
	swc1 $f0, 0($a0)
	addi $t1, $t1, 1
	sw $t1, indexofTresult
	
	la $a0, AddingSuccess
	li $v0, 4
	syscall
	
	j menu
######### Read Test result for BPT Test #########
ReadTwoNewResults:
	la $a2, TresultArray
	lw $t1, indexofTresult
	sll $t1, $t1, 3
	add $a2, $a2, $t1
	la $a0, SBPTresultMsg1
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	swc1 $f0, 0($a2)	# Store the SBP result
	
	la $a0, DBPTresultMsg1
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	swc1 $f0, 4($a2)	# Store the DBP result
	
	addi $t1, $t1, 1
	sw $t1, indexofTresult
	
	la $a0, AddingSuccess
	li $v0, 4
	syscall
			
	j menu
######################################################### Checking the validation of the patient ID ################################################	
checkPID:
	la $t0, lineBuffer
	li $t1, 0	# store the number of digits of ID
traverse_loop:
	lb $t2, 0($t0)
	beqz $t2, checkDigits
	beq $t2, 10, checkDigits
	blt $t2, 48, ErrorID
	bgt $t2, 57, ErrorID 
	addi $t1, $t1, 1
	addiu $t0, $t0, 1
	j traverse_loop
	
checkDigits:
	bne $t1, 7, ErrorID
	j storeValidID
ErrorID: 
	la $a0, ErMsgID
	li $v0, 4
	syscall
	j ReadnewID

######################################################### Checking the validation of the test name ################################################		
checkTname:
	la $a0, lineBuffer
	li $t0, 0	 # store the length of the medical test name
travers_loop_Tname:
	lb $t1, 0($a0)
	beqz $t1, checkLength
	beq $t1, 10, checkLength
	addi $t0, $t0, 1
	addiu $a0, $a0, 1
	j travers_loop_Tname
checkLength:
	bne $t0, 3, ErrorTname
	j ValidName

ErrorTname:
	la $a0, ErrorMsgTname
	li $v0, 4
	syscall
	j ReadnewTname
ValidName:
	la $a0, lineBuffer             # Address of the input buffer
    	la $a1, validName1             # First valid test name
    	jal string_compare             # Call the string comparison function
    	beq $v0, 1, NameIsValid        # If return is 1, name is valid

    	la $a1, validName2             # Second valid test name
    	jal string_compare             # Call the string comparison function
    	beq $v0, 1, NameIsValid        # If return is 1, name is valid

    	la $a1, validName3             # Third valid test name
    	jal string_compare             # Call the string comparison function
    	beq $v0, 1, NameIsValid        # If return is 1, name is valid

    	la $a1, validName4             # Fourth valid test name
    	jal string_compare             # Call the string comparison function
    	beq $v0, 1, NameIsValid        # If return is 1, name is valid

    	j ErrorTname                   # If no match, jump to error handling

NameIsValid:
    	# Continue with further processing if the name is valid
    	j storeValidTname           # Assuming there's a label to handle further steps

# String comparison function, returns 1 in $v0 if strings are equal, 0 otherwise
string_compare:
    	move $t2, $a0                  # Pointer to first string
    	move $t3, $a1                  # Pointer to second string

compare_loop:
    	lb $t0, 0($t2)                 # Load byte from first string
    	lb $t1, 0($t3)                 # Load byte from second string
    	beqz $t1, compare_success      # If we reach '\0', strings are equal
    	beqz $t0, compare_success 
    	beq $t0, 10, compare_success
    	beq $t1, 10, compare_success
    	bne $t0, $t1, compare_fail     # If bytes are not equal, fail
    	addiu $t2, $t2, 1              # Increment pointer
    	addiu $t3, $t3, 1              # Increment pointer
    	j compare_loop                 # Loop back

compare_fail:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success:
    	li $v0, 1                      # Set return value to 1
    	jr $ra                         # Return
######################################################## Checking the validation of medical test date ##################################################
checkTdate:
	la $a0, tempDate
	li $t0, 0
Traverse1:
	lb $t1, 0($a0)
	beqz $t1, checkNOFchar
	beq $t1, 10, checkNOFchar
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j Traverse1

checkNOFchar:
	bne $t0, 7, dateError

# Here the date has 7 charachters
checkFormat:
	la $a0, tempDate	# Load address of the input date
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	lb $t2, 2($a0)
	lb $t3, 3($a0)
	lb $t4, 4($a0)
	lb $t5, 5($a0)
	lb $t6, 6($a0)
	bne $t4, 45, dateError	# check if the fifth charachter is '-' 
# Here we check that other charachters are numbers 
	bgt $t0, 57, dateError
	blt $t0, 48, dateError
	bgt $t1, 57, dateError
	blt $t1, 48, dateError
	bgt $t2, 57, dateError
	blt $t2, 48, dateError
	bgt $t3, 57, dateError
	blt $t3, 48, dateError
	bgt $t5, 57, dateError
	blt $t5, 48, dateError
	bgt $t6, 57, dateError
	blt $t6, 48, dateError
	
	
# Here the date has the correct format "YYYY-MM"
    	la $a0, tempDate          # Load address of the input date
    	li $t0, 0
    	li $t1, 0                 # t1 will hold the year
    	li $t2, 0                 # t2 will hold the month

    	# Extract the year (first four characters)
    	lb $t3, 0($a0)
    	lb $t4, 1($a0)
    	lb $t5, 2($a0)
    	lb $t6, 3($a0)
    	# Convert characters to integer
    	li $t7, 10
    	subi $t3, $t3, '0'
    	subi $t4, $t4, '0'
    	subi $t5, $t5, '0'
    	subi $t6, $t6, '0'
    	mul $t3, $t3, 1000
    	mul $t4, $t4, 100
   	mul $t5, $t5, 10
    	add $t1, $t1, $t3
    	add $t1, $t1, $t4
    	add $t1, $t1, $t5
    	add $t1, $t1, $t6
    
    	# Extract the month (characters 6 and 7)
    	lb $t3, 5($a0)
    	lb $t4, 6($a0)
    	subi $t3, $t3, '0'
    	subi $t4, $t4, '0'
    	mul $t3, $t3, 10
    	add $t2, $t2, $t3
    	add $t2, $t2, $t4
    
    	# Validate the date is not in the future
    	lw $t5, currentYear
    	lw $t6, currentMonth
    	bgt $t1, $t5, dateError     # Check if the year is greater than the current year
    	bne $t1, $t5, storeValidTdate # If year is not equal, no need to check month
    	bgt $t2, $t6, dateError     # Check if the month is greater than the current month

    	j storeValidTdate           # Jump to storing the valid date

dateError:
    	la $a0, dateErrorMsg
    	li $v0, 4
    	syscall
    	j ReadnewTdate

######################################################## Searching for a test by patient ID ##################################################################
Searching_for_test_By_PatientID:
	la $a0, ReadingIDMsg2	# message to read the patient's ID
	li $v0, 4
	syscall
	
	# Clear Line Buffer
	la $a0, lineBuffer
	li $t0, 0
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	# Read the ID number
	la $a0, lineBuffer
	li $a1, 20
	li $v0, 8
	syscall
# check if the input ID is valid or not
checkValidation1:
	la $a0, lineBuffer
	li $t1, 0	# store the number of digits of ID
traverse_loop1:
	lb $t2, 0($a0)
	beqz $t2, checkDigits1
	beq $t2, 10, checkDigits1
	blt $t2, 48, ErrorID1
	bgt $t2, 57, ErrorID1
	addi $t1, $t1, 1
	addiu $a0, $a0, 1
	j traverse_loop1
	
checkDigits1:
	bne $t1, 7, ErrorID1
	j converting1
ErrorID1: 
	la $a0, ErMsgID
	li $v0, 4
	syscall
	j Searching_for_test_By_PatientID

# convert the input ID into integer datatype
converting1:
	la $a0, lineBuffer
	li $t0, 0	# store the input ID in $t0
convertIntID1:
	lb $t1, 0($a0)
	beqz $t1, searchInIDArray
	beq $t1, 10, searchInIDArray
	subi $t1, $t1, '0'
	
	li $t2, 10
	
	mul $t0, $t0, $t2
	
	add $t0, $t0, $t1
	
	addiu $a0, $a0, 1
	j convertIntID1
	
# check if the input ID is exist in the Array	
# $t0 has the input ID
searchInIDArray:
	la $a1, IDArray
	lw $t1, index	# store the last index we have reached in storing the data in the ID Array
	li $t2, 0	# store the initial index then traverse through the array
traverse_IDarray:
	beq $t2, $t1, IDDoesNotExist
	sll $t2, $t2, 2 
	add $a1, $a1, $t2
	lw $t3, 0($a1)
	la $a1, IDArray
	addi $t2, $t2, 1
	bne $t3, $t0, traverse_IDarray

# ID Exist in the Array
IDExist:
	la $a0, menuSelection2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 1, RetrieveAllTests
	beq $v0, 2, RetrieveUpNormal
	beq $v0, 3, RetrieveTestsDependingOnPeriod
	
	la $a0, ErrorSelection
	li $v0, 4
	syscall
	j IDExist
# ID Does not Exist in the Array
IDDoesNotExist:
	la $a0, IDnotExist
	li $v0, 4
	syscall
	j Searching_for_test_By_PatientID	

########################### Retrieve all patient tests ########################
# $t0 has the input ID
RetrieveAllTests:
	move $s0, $t0
	la $a2, IDArray
	lw $t0, index
	li $t1, 0	# store the actual index of the array
	li $t2, 0	# store the fake index of the array ([0], [1], [2], .....)
traverse_IDArray1:
	beq $t0, $t1, EndOfIDAyyar
	sll $t1, $t1, 2
	add $a2, $a2, $t1
	lw $t3, 0($a2)
	la $a2, IDArray
	addi $t1, $t1, 1
	beq $s0, $t3, TestExistsHere
	addi $t2, $t2, 1
	j traverse_IDArray1
	
TestExistsHere:
	# $t2 has the fake index
	move $s1, $t2	# Save the fake index
	li $t3, 0	# reaching the actual index of the Test and store it here
	li $t4, 0	# reaching the actual index of the Test and store it here
# Find the Actual index of result array and name array and date array
calculateActualIndex:
	beqz $s1, printTest
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	sll $t3, $t3, 2
	sll $t4, $t4, 3
	subi $s1, $s1, 1
	j calculateActualIndex

printTest:
	# print medical test name
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t4
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare3             # Call the string comparison function
    	beq $v0, 1, NameIsBPT        # If return is 1, name is valid
    	j NameIsNotBPT
    	
string_compare3:
    	move $t5, $a1                  # Pointer to first string
    	move $t6, $a0                  # Pointer to second string

compare_loop3:
    	lb $t7, 0($t5)                 # Load byte from first string
    	lb $t8, 0($t6)                 # Load byte from second string
    	beqz $t8, compare_success3      # If we reach '\0', strings are equal
    	beqz $t7, compare_success3 
    	beq $t7, 10, compare_success3
    	beq $t7, 10, compare_success3
    	bne $t7, $t8, compare_fail3     # If bytes are not equal, fail
    	addiu $t5, $t5, 1              # Increment pointer
    	addiu $t6, $t6, 1              # Increment pointer
    	j compare_loop3                 # Loop back

compare_fail3:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success3:
    	li $v0, 1                      # Set return value to 1
    	jr $ra  	
################### The Test is not BPT
NameIsNotBPT:	
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	
	addi $t2, $t2, 1
	j traverse_IDArray1
	
NameIsBPT:
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall
	
	addi $t2, $t2, 1
	j traverse_IDArray1
########################### Retrieve all up normal patient tests ########################
# $t0 has the input ID
RetrieveUpNormal:
	move $s0, $t0
	# Load the ID array to trverse through it to find the inexes where the ID number of the patient is exist
	la $a2, IDArray
	lw $t0, index
	li $t1, 0	# store the actual index of the array
	li $t2, 0	# store the fake index of the array ([0], [1], [2], .....)
traverse_IDArray2:
	lw $t0, index
	beq $t0, $t1, EndOfIDAyyar
	sll $t1, $t1, 2
	add $a2, $a2, $t1
	lw $t3, 0($a2)
	la $a2, IDArray
	addi $t1, $t1, 1
	beq $s0, $t3, TestExistsHere2
	addi $t2, $t2, 1
	j traverse_IDArray2
	
TestExistsHere2:
	# $t2 has the fake index
	move $s1, $t2	# Save the fake index
	li $t3, 0	# reaching the actual index of the Test and store it here(ID and name)
	li $t4, 0	# reaching the actual index of the Test and store it here(result and date)
# Find the Actual index of result array and name array and date array
calculateActualIndex2:
	beqz $s1, CheckUpNormal2
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	sll $t3, $t3, 2
	sll $t4, $t4, 3
	subi $s1, $s1, 1
	j calculateActualIndex2
	
CheckUpNormal2:
	# load the Test name array to specify the medical test
	la $a1, TnameArray
	# load and clear the line buffer
	la $t0, lineBuffer
	li $t5, 0
	sw $t5, 0($t0)
	sw $t5, 4($t0)
	# load the Test name from Array into line buffer
	add $a1, $a1, $t3
	lb $t5, 0($a1)
	sb $t5, 0($t0)
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	lb $t5, 0($a1)
	sb $t5, 0($t0)
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	lb $t5, 0($a1)
	sb $t5, 0($t0)
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	# line buffer has the test name
	### Determine what is the test to know if the result is normal or upnormal
	la $a0, lineBuffer
	la $a1, validName1
	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, HgbMedicalTest
    	
    	la $a1, validName2
    	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, BGTMedicalTest
    	
    	la $a1, validName3
    	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, LDLMedicalTest
    	
    	la $a1, validName4
    	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, BPTMedicalTest
    	
string_compare5:
    	move $t5, $a1                  # Pointer to first string
    	move $t6, $a0                  # Pointer to second string

compare_loop5:
    	lb $t7, 0($t5)                 # Load byte from first string
    	lb $t8, 0($t6)                 # Load byte from second string
    	beqz $t8, compare_success5      # If we reach '\0', strings are equal
    	beqz $t7, compare_success5
    	beq $t8, 10, compare_success5
    	beq $t7, 10, compare_success5
    	bne $t7, $t8, compare_fail5     # If bytes are not equal, fail
    	addiu $t5, $t5, 1              # Increment pointer
    	addiu $t6, $t6, 1              # Increment pointer
    	j compare_loop5                 # Loop back

compare_fail5:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success5:
    	li $v0, 1                      # Set return value to 1
    	jr $ra
########## check if the test is un normal or not
############################# The test is Hgb ################################
HgbMedicalTest:
	la $a1, TresultArray
	la $a0, RangeofHgb
	add $a1, $a1, $t4	# reach to the result of the specific patient
	lwc1 $f0, 0($a1)	# load the result in $f0
	lwc1 $f1, 0($a0)
	lwc1 $f2, 4($a0)
	
	li $s2, 1 # to determine that the test is Hgb 
	
	c.lt.s $f0, $f1
	bc1t PrintUnNormalTest2
	c.lt.s $f0, $f2
	bc1f PrintUnNormalTest2
	
	addi $t2, $t2, 1
	j traverse_IDArray2
############################# The test is BGT ################################
BGTMedicalTest:
	la $a1, TresultArray
	la $a0, RangeofBGT
	add $a1, $a1, $t4	# reach to the result of the specific patient
	lwc1 $f0, 0($a1)	# load the result in $f0
	lwc1 $f1, 0($a0)
	lwc1 $f2, 4($a0)
	
	li $s2, 2 # to determine that the test is BGT
	
	c.lt.s $f0, $f1
	bc1t PrintUnNormalTest2
	c.lt.s $f0, $f2
	bc1f PrintUnNormalTest2
	
	addi $t2, $t2, 1
	j traverse_IDArray2
############################# The test is LDL ################################
LDLMedicalTest:
	la $a1, TresultArray
	la $a0, RangeofLDL
	add $a1, $a1, $t4	# reach to the result of the specific patient
	lwc1 $f0, 0($a1)	# load the result in $f0
	lwc1 $f1, 0($a0)
	
	li $s2, 3 # to determine that the test is LDL
	
	c.lt.s $f0, $f1
	bc1f PrintUnNormalTest2
	
	addi $t2, $t2, 1
	j traverse_IDArray2
############################# The test is BPT ################################
BPTMedicalTest:
	la $a1, TresultArray
	la $a0, RangeofBPT
	add $a1, $a1, $t4	# reach to the result of the specific patient
	lwc1 $f0, 0($a1)	# load the result of SBP in $f0 
	lwc1 $f1, 4($a1)	# load the result of DBP in $f1 
	lwc1 $f2, 0($a0)
	lwc1 $f3, 4($a0)
	
	li $s2, 4 # to determine that the test is BPT
	
	c.lt.s $f0, $f2
	bc1f PrintUnNormalTest2
	c.lt.s $f1, $f3
	bc1f PrintUnNormalTest2
	
	addi $t2, $t2, 1
	j traverse_IDArray2
############################# Print the unnormal test ################################
PrintUnNormalTest2:
	# print medical test name
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t4
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, NameIsBPT2        # If return is 1, name is valid
    	j NameIsNotBPT2
    		
################### The Test is not BPT
NameIsNotBPT2:	
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	beq $s2, 1, Hgb
	beq $s2, 2, BGT
	beq $s2, 3, LDL
Hgb:
	la $a0, MeasuringUnitHgb
	li $v0, 4
	syscall
	j continueTraverse_IDArray2
BGT:
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j continueTraverse_IDArray2
LDL:	
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j continueTraverse_IDArray2
continueTraverse_IDArray2:
	addi $t2, $t2, 1
	j traverse_IDArray2
################### The Test is BPT	
NameIsBPT2:
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall
	
	la $a0, MeasuringUnitBPT
	li $v0, 4
	syscall
	
	addi $t2, $t2, 1
	j traverse_IDArray2
########################### Retrieve all patient tests in a given specific period ########################
# $t0 has the input ID
RetrieveTestsDependingOnPeriod:
	move $s0, $t0
ReadBeginningDate:
	la $a0, date1Msg2
	li $v0, 4
	syscall
	# Read the beginning of the period
	la $a0, beginningPeriod
	li $a1, 20
	li $v0, 8
	syscall
########### check the validation of beginning date it should be in 'YYYY-MM' format and before the current date
checkBeginningdate:
	la $a0, beginningPeriod
	li $t0, 0
Traverse2:
	lb $t1, 0($a0)
	beqz $t1, checkNOFchar1
	beq $t1, 10, checkNOFchar1
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j Traverse2

checkNOFchar1:
	bne $t0, 7, dateError1

# Here the date has 7 charachters
checkFormat1:
	la $a0, beginningPeriod	# Load address of the input date
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	lb $t2, 2($a0)
	lb $t3, 3($a0)
	lb $t4, 4($a0)
	lb $t5, 5($a0)
	lb $t6, 6($a0)
	bne $t4, 45, dateError1	# check if the fifth charachter is '-' 
# Here we check that other charachters are numbers 
	bgt $t0, 57, dateError1
	blt $t0, 48, dateError1
	bgt $t1, 57, dateError1
	blt $t1, 48, dateError1
	bgt $t2, 57, dateError1
	blt $t2, 48, dateError1
	bgt $t3, 57, dateError1
	blt $t3, 48, dateError1
	bgt $t5, 57, dateError1
	blt $t5, 48, dateError1
	bgt $t6, 57, dateError1
	blt $t6, 48, dateError1
	
	
# Here the date has the correct format "YYYY-MM"
    	la $a0, beginningPeriod          # Load address of the input date
    	li $t0, 0
    	li $t1, 0                 # t1 will hold the year
    	li $t2, 0                 # t2 will hold the month

    	# Extract the year (first four characters)
    	lb $t3, 0($a0)
    	lb $t4, 1($a0)
    	lb $t5, 2($a0)
    	lb $t6, 3($a0)
    	# Convert characters to integer
    	li $t7, 10
    	subi $t3, $t3, '0'
    	subi $t4, $t4, '0'
    	subi $t5, $t5, '0'
    	subi $t6, $t6, '0'
    	mul $t3, $t3, 1000
    	mul $t4, $t4, 100
   	mul $t5, $t5, 10
    	add $t1, $t1, $t3
    	add $t1, $t1, $t4
    	add $t1, $t1, $t5
    	add $t1, $t1, $t6
    
    	# Extract the month (characters 6 and 7)
    	lb $t3, 5($a0)
    	lb $t4, 6($a0)
    	subi $t3, $t3, '0'
    	subi $t4, $t4, '0'
    	mul $t3, $t3, 10
    	add $t2, $t2, $t3
    	add $t2, $t2, $t4
    
    	# Validate the date is not in the future
    	lw $t5, currentYear
    	lw $t6, currentMonth
    	bgt $t1, $t5, dateError1     # Check if the year is greater than the current year
    	bne $t1, $t5, ReadingEndingDate # If year is not equal, no need to check month
    	bgt $t2, $t6, dateError1     # Check if the month is greater than the current month

    	j ReadingEndingDate           # Jump to storing the valid date

dateError1:
    	la $a0, BeginningdateErrorMsg
    	li $v0, 4
    	syscall
    	j ReadBeginningDate
    	
############################
ReadingEndingDate:
	la $a0, date2Msg2
	li $v0, 4
	syscall
	# Read the ending of the period
	la $a0, endingPeriod
	li $a1, 20
	li $v0, 8
	syscall
########### check the validation of beginning date it should be in 'YYYY-MM' format
checkEndingdate:
	la $a0, endingPeriod
	li $t0, 0
Traverse3:
	lb $t1, 0($a0)
	beqz $t1, checkNOFchar2
	beq $t1, 10, checkNOFchar2
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j Traverse3

checkNOFchar2:
	bne $t0, 7, dateError2

# Here the date has 7 charachters
checkFormat2:
	la $a0, endingPeriod	# Load address of the input date
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	lb $t2, 2($a0)
	lb $t3, 3($a0)
	lb $t4, 4($a0)
	lb $t5, 5($a0)
	lb $t6, 6($a0)
	bne $t4, 45, dateError2	# check if the fifth charachter is '-' 
# Here we check that other charachters are numbers 
	bgt $t0, 57, dateError2
	blt $t0, 48, dateError2
	bgt $t1, 57, dateError2
	blt $t1, 48, dateError2
	bgt $t2, 57, dateError2
	blt $t2, 48, dateError2
	bgt $t3, 57, dateError2
	blt $t3, 48, dateError2
	bgt $t5, 57, dateError2
	blt $t5, 48, dateError2
	bgt $t6, 57, dateError2
	blt $t6, 48, dateError2
	
	j ContinueSearching

dateError2:
    	la $a0, EndingdateErrorMsg
    	li $v0, 4
    	syscall
    	j ReadingEndingDate
PeriodError:
	la $a0, EndingdateErrorMsg2
    	li $v0, 4
    	syscall
    	j ReadBeginningDate
###################### Continue Searching
ContinueSearching:
	# Storing year of beginning date in $s2
	la $a0, beginningPeriod
	li $t4, 4
	li $t8, 1000
	li $t9, 10
	li $s2, 0
YearBeginningLoop:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s2, $s2, $t6
	div $t8, $t8, $t9
	subi $t4, $t4, 1
	addi $a0, $a0, 1
	beqz $t4, StoringMonth1
	j YearBeginningLoop
	# Storing month of beginning date in $s3
StoringMonth1:
	addi $a0, $a0, 1	#  Skip the dash '-'
	li $t4, 2
	li $t8, 10
	li $t9, 10
	li $s3, 0
MonthBeginningLoop:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s3, $s3, $t6
	div $t8, $t8, $t9
	subi $t4, $t4, 1
	addi $a0, $a0, 1
	beqz $t4, StoringYear2
	j MonthBeginningLoop
	# Storing year of ending date in $s4
StoringYear2:
	la $a0, endingPeriod
	li $t4, 4
	li $t8, 1000
	li $t9, 10
	li $s4, 0
YearEndingLoop:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s4, $s4, $t6
	div $t8, $t8, $t9
	subi $t4, $t4, 1
	addi $a0, $a0, 1
	beqz $t4, StoringMonth2
	j YearEndingLoop	
	# Storing month of ending date in $s5
StoringMonth2:
	addi $a0, $a0, 1	#  Skip the dash '-'
	li $t4, 2
	li $t8, 10
	li $t9, 10
	li $s5, 0
MonthEndingLoop:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s5, $s5, $t6
	div $t8, $t8, $t9
	subi $t4, $t4, 1
	addi $a0, $a0, 1
	beqz $t4, DONEDATE
	j MonthEndingLoop

DONEDATE:
	# Check the validationof period (if End date after Beginning date)
	bgt $s2, $s4, PeriodError
	beq $s2, $s4, CheckMonths
	bne $s2, $s4, LoadIDArray
CheckMonths:
	bgt $s3, $s5, PeriodError
LoadIDArray:
	# $s0 has the ID number
	la $a2, IDArray
	lw $t0, index
	li $t1, 0	# store the actual index of the array
	li $t2, 0	# store the fake index of the array ([0], [1], [2], .....)
traverse_IDArray3:
	beq $t0, $t1, EndOfIDAyyar
	sll $t1, $t1, 2
	add $a2, $a2, $t1
	lw $t3, 0($a2)
	la $a2, IDArray
	addi $t1, $t1, 1
	beq $s0, $t3, TestExistsHere3
	addi $t2, $t2, 1
	j traverse_IDArray3

TestExistsHere3:
	# $t2 has the fake index
	move $s1, $t2	# Save the fake index
	li $t3, 0	# reaching the actual index of the Test and store it here
	li $t4, 0	# reaching the actual index of the Test and store it here
# Find the Actual index of result array and name array and date array
calculateActualIndex3:
	beqz $s1, TestTheDateInPeriod
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	sll $t3, $t3, 2
	sll $t4, $t4, 3
	subi $s1, $s1, 1
	j calculateActualIndex3
#################### Test if the date is in the given period
TestTheDateInPeriod:
	la $a0, TdateArray
	la $a1, tempDate
	li $t5, 0
	sw $t5 0($a1)
	sw $t5 4($a1)
	sw $t5 8($a1)
	add $a0, $a0, $t4
takeTheDate:
	lb $t5, 0($a0)
	beqz $t5, ConvertDate
	beq $t5, 10, ConvertDate
	sb $t5, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j takeTheDate

ConvertDate:
	la $a0, tempDate
	li $s6, 0
	li $t7, 4
	li $t8, 1000
	li $t9, 10
YearLoop1:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s6, $s6, $t6
	div $t8, $t8, $t9
	subi $t7, $t7, 1
	addi $a0, $a0, 1
	beqz $t7, ConvertMonth
	j YearLoop1
	# Storing month of beginning date in $s3
ConvertMonth:
	addi $a0, $a0, 1	#  Skip the dash '-'
	li $t7, 2
	li $t8, 10
	li $t9, 10
	li $s7, 0
MonthLoop1:
	lb $t5, 0($a0)
	subi $t5, $t5, '0'
	mul $t6, $t5, $t8
	add $s7, $s7, $t6
	div $t8, $t8, $t9
	subi $t7, $t7, 1
	addi $a0, $a0, 1
	beqz $t7, ConvertingDateDone
	j MonthLoop1

ConvertingDateDone:
	bgt $s6, $s4, NotIncludedDate
	blt $s6, $s2, NotIncludedDate
	beq $s6, $s2, TestTheMonth1
	beq $s6, $s4, TestTheMonth2
	bne $s6, $s2, PrintTheTest3
NotIncludedDate:
	addi $t2, $t2, 1
	j traverse_IDArray3

TestTheMonth1:
	blt $s7, $s3, NotIncludedDate
	bge $s7, $s3, PrintTheTest3
TestTheMonth2:
	bgt $s7, $s5, NotIncludedDate
	ble $s7, $s5, PrintTheTest3
	
PrintTheTest3:
	# print medical test name
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t4
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare4             # Call the string comparison function
    	beq $v0, 1, NameIsBPT3        # If return is 1, name is valid
    	j NameIsNotBPT3
    	
string_compare4:
    	move $t5, $a1                  # Pointer to first string
    	move $t6, $a0                  # Pointer to second string

compare_loop4:
    	lb $t7, 0($t5)                 # Load byte from first string
    	lb $t8, 0($t6)                 # Load byte from second string
    	beqz $t8, compare_success4      # If we reach '\0', strings are equal
    	beqz $t7, compare_success4 
    	beq $t7, 10, compare_success4
    	beq $t7, 10, compare_success4
    	bne $t7, $t8, compare_fail4     # If bytes are not equal, fail
    	addiu $t5, $t5, 1              # Increment pointer
    	addiu $t6, $t6, 1              # Increment pointer
    	j compare_loop4                 # Loop back

compare_fail4:
    	li $v0, 0                      # Set return value to 0
    	jr $ra                         # Return

compare_success4:
    	li $v0, 1                      # Set return value to 1
    	jr $ra  	
################### The Test is not BPT
NameIsNotBPT3:	
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	
	addi $t2, $t2, 1
	j traverse_IDArray3
	
NameIsBPT3:
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall
	
	addi $t2, $t2, 1
	j traverse_IDArray3		
########################### Ending of Searching ########################
EndOfIDAyyar:
	j menu
######################################################## Searching for unnormal tests ##################################################################
Searching_for_Unnormal_Tests:
	# print the Menu of the Medical tests
	la $a0, MedicalTestNameMenu
	li $v0, 4
	syscall
	
	# Read the input from user
	li $v0, 5
	syscall
	move $s0, $v0	# store the selection in $s0
	
	beq $s0, 1, SelectionHgb
	beq $s0, 2, SelectionBGT
	beq $s0, 3, SelectionLDL
	beq $s0, 4, SelectionBPT
	
	la $a0, ErrorSelection
	li $v0, 4
	syscall
	j Searching_for_Unnormal_Tests
	
########################### Selection is Hgb ##############################
SelectionHgb:
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
	la $a1, validName1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	j ContinueSearching3
########################### Selection is BGT ##############################
SelectionBGT:
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
	la $a1, validName2
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	j ContinueSearching3
########################### Selection is LDL ##############################
SelectionLDL:
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
	la $a1, validName3
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	j ContinueSearching3
########################### Selection is BPT ##############################
SelectionBPT:
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
	la $a1, validName4
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	j ContinueSearching3
################################### Test name is stored in line buffer 	
ContinueSearching3:
	la $a2, TnameArray
	lw $s0, indexofTname
	li $t0, 0	# store the actual index of test name
	li $s1, 0	# store the fake index of test name ([0], [1], [2], ...)
traverse_TnameArray:
	beq $t0, $s0, EndofTnameArray
	sll $t0, $t0, 2
	add $a1, $a2, $t0
	addi $t0, $t0, 1
	la $a0, lineBuffer
	jal string_compare4
	beq $v0, 1, TestExistHere
	addi $s1, $s1, 1
	j traverse_TnameArray
	
TestExistHere:
	move $t1, $s1
	# Determine the actual index of Tdate and Tresult
	li $t2, 0
	li $t3, 0
DetermineTheActualIndex:
	sll $t2, $t2, 3
	sll $t3, $t3, 2
	beq $t1, 0, ReachingTheIndex
	subi $t1, $t1, 1
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	j DetermineTheActualIndex
	
ReachingTheIndex:
	# $t2 has the index of test date and test result
	# $t3 has the index of test name and ID
	la $a0, lineBuffer
	la $a1, validName1
	jal string_compare4
	beq $v0, 1, HgbTestName
	
	la $a1, validName2
	jal string_compare4
	beq $v0, 1, BGTTestName
	
	la $a1, validName3
	jal string_compare4
	beq $v0, 1, LDLTestName
	
	la $a1, validName4
	jal string_compare4
	beq $v0, 1, BPTTestName
############# check if the test is normal or unnormal ################
HgbTestName:
	la $a0, TresultArray
	la $t4, RangeofHgb
	add $a0, $a0, $t2
	lwc1 $f0, 0($a0)
	lwc1 $f1, 0($t4)
	lwc1 $f2, 4($t4)
	
	li $s2, 1
	
	c.lt.s $f0, $f1
	bc1t PrintUnnormal3
	
	c.le.s $f0, $f1
	bc1f PrintUnnormal3
	
	addi $s1, $s1, 1
	j traverse_TnameArray
BGTTestName:
	la $a0, TresultArray
	la $t4, RangeofBGT
	add $a0, $a0, $t2
	lwc1 $f0, 0($a0)
	lwc1 $f1, 0($t4)
	lwc1 $f2, 4($t4)
	
	li $s2, 2
	
	c.lt.s $f0, $f1
	bc1t PrintUnnormal3
	
	c.le.s $f0, $f1
	bc1f PrintUnnormal3
	
	addi $s1, $s1, 1
	j traverse_TnameArray
LDLTestName:
	la $a0, TresultArray
	la $t4, RangeofLDL
	add $a0, $a0, $t2
	lwc1 $f0, 0($a0)
	lwc1 $f1, 0($t4)
	
	li $s2, 3
	
	c.lt.s $f0, $f1
	bc1f PrintUnnormal3
	
	addi $s1, $s1, 1
	j traverse_TnameArray
BPTTestName:
	la $a0, TresultArray
	la $t4, RangeofBPT
	add $a0, $a0, $t2
	lwc1 $f0, 0($a0)
	lwc1 $f1, 4($a0)
	lwc1 $f2, 0($t4)
	lwc1 $f3, 4($t4)
	
	li $s2, 4
	
	c.lt.s $f0, $f2
	bc1f PrintUnnormal3
	
	c.lt.s $f1, $f3
	bc1f PrintUnnormal3
	
	addi $s1, $s1, 1
	j traverse_TnameArray
PrintUnnormal3:	
	# print medical test name
	la $a0, IDMP
	li $v0, 4
	syscall
	la $a0, IDArray
	add $a0, $a0, $t3
	lw $k1, 0($a0)
	move $a0, $k1
	li $v0, 1
	syscall
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t2
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare5             # Call the string comparison function
    	beq $v0, 1, NameIsBPT4       # If return is 1, name is valid
    	j NameIsNotBPT4
    		
################### The Test is not BPT
NameIsNotBPT4:	
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t2
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	beq $s2, 1, Hgb3
	beq $s2, 2, BGT3
	beq $s2, 3, LDL3
Hgb3:
	la $a0, MeasuringUnitHgb
	li $v0, 4
	syscall
	j continueTraverse_TnameArray
BGT3:
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j continueTraverse_TnameArray
LDL3:	
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j continueTraverse_TnameArray
continueTraverse_TnameArray:
	addi $s1, $s1, 1
	j traverse_TnameArray
################### The Test is BPT	
NameIsBPT4:
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t2
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall
	
	la $a0, MeasuringUnitBPT
	li $v0, 4
	syscall
	
	addi $s1, $s1, 1
	j traverse_TnameArray	
################################### Ending of Test name array #################################
EndofTnameArray:
	j menu		
######################################################## Average Test Value ##################################################################
AverageTestValue:
	li $s2, 0	# store the num of Hgb tests
	li $s3, 0	# store the num of BGT tests
	li $s4, 0	# store the num of LDL tests
	li $s5, 0	# store the num of BPT tests
	mtc1 $s2 $f0	# store the sum of Hgb tests
	mtc1 $s2 $f1	# store the sum of BGT tests
	mtc1 $s2 $f2	# store the sum of LDL tests
	mtc1 $s2 $f3	# store the sum of BPT tests (SBP)
	mtc1 $s2 $f4	# store the sum of BPT tests (DBP)
	la $a2, TnameArray
	lw $s0, indexofTname
	li $t0, 0	# store the actual index of test name
	li $s1, 0	# store the fake index of test name ([0], [1], [2], ...)
traverse_TnameArray4:
	beq $t0, $s0, AverageHgb
	sll $t0, $t0, 2
	add $a1, $a2, $t0
	addi $t0, $t0, 1
	la $a0, validName1
	jal string_compare4
	beq $v0, 1, TestExistHere4
	la $a0, validName2
	jal string_compare4
	beq $v0, 1, TestExistHere4
	la $a0, validName3
	jal string_compare4
	beq $v0, 1, TestExistHere4
	la $a0, validName4
	jal string_compare4
	beq $v0, 1, TestExistHere4
	addi $s1, $s1, 1
	j traverse_TnameArray4
	
TestExistHere4:
	move $t1, $s1
	# Determine the actual index of Tdate and Tresult
	li $t2, 0
	li $t3, 0
DetermineTheActualIndex4:
	sll $t2, $t2, 3
	sll $t3, $t3, 2
	beq $t1, 0, ReachingTheIndex4
	subi $t1, $t1, 1
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	j DetermineTheActualIndex4
	
ReachingTheIndex4:
	# $t2 has the index of test date and test result
	# $t3 has the index of test name
	la $a0, validName1
	jal string_compare4
	beq $v0, 1, HgbSum
	
	la $a0, validName2
	jal string_compare4
	beq $v0, 1, BGTSum
	
	la $a0, validName3
	jal string_compare4
	beq $v0, 1, LDLSum
	
	la $a0, validName4
	jal string_compare4
	beq $v0, 1, BPTSum
# Calculate the sum of Hgb test results
HgbSum:
	addi $s2, $s2, 1
	la $t4, TresultArray
	add $t4, $t4, $t2
	lwc1 $f5, 0($t4)
	add.s $f0, $f0, $f5
	
	addi $s1, $s1, 1
	j traverse_TnameArray4
# Calculate the sum of BGT test results
BGTSum:
	addi $s3, $s3, 1
	la $t4, TresultArray
	add $t4, $t4, $t2
	lwc1 $f5, 0($t4)
	add.s $f1, $f1, $f5
	
	addi $s1, $s1, 1
	j traverse_TnameArray4
# Calculate the sum of LDL test results
LDLSum:
	addi $s4, $s4, 1
	la $t4, TresultArray
	add $t4, $t4, $t2
	lwc1 $f5, 0($t4)
	add.s $f2, $f2, $f5
	
	addi $s1, $s1, 1
	j traverse_TnameArray4
# Calculate the sum of BPT test results
BPTSum:
	addi $s5, $s5, 1
	la $t4, TresultArray
	add $t4, $t4, $t2
	lwc1 $f5, 0($t4)
	lwc1 $f6, 4($t4)
	add.s $f3, $f3, $f5
	add.s $f4, $f4, $f6
	
	addi $s1, $s1, 1
	j traverse_TnameArray4
AverageHgb:
	la $a0, AverageHgbMsg
	li $v0, 4
	syscall
	# Calculate the average for Hgb
	beqz $s2, NonHgb	# if number of Hgb tests is 0 then go to the next test
	mtc1 $s2, $f7
	cvt.s.w $f7, $f7
	div.s $f8, $f0, $f7
	mov.s $f12, $f8
	li $v0, 2
	syscall
	la $a0, MeasuringUnitHgb
	li $v0, 4
	syscall
	j AverageBGT
NonHgb:
	li $s6, 0
	mtc1 $s6, $f12
	cvt.s.w $f12, $f12
	li $v0, 2
	syscall
	la $a0, MeasuringUnitHgb
	li $v0, 4
	syscall
AverageBGT:
	la $a0, AverageBGTMsg
	li $v0, 4
	syscall
	# Calculate the average for BGT
	beqz $s3, NonBGT
	mtc1 $s3, $f7
	cvt.s.w $f7, $f7
	div.s $f8, $f1, $f7
	mov.s $f12, $f8
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j AverageLDL
NonBGT:
	li $s6, 0
	mtc1 $s6, $f12
	cvt.s.w $f12, $f12
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
AverageLDL:
	la $a0, AverageLDLMsg
	li $v0, 4
	syscall
	# Calculate the average for LDL
	beqz $s4, NonLDL
	mtc1 $s4, $f7
	cvt.s.w $f7, $f7
	div.s $f8, $f2, $f7
	mov.s $f12, $f8
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
	j AverageBPT
NonLDL:
	li $s6, 0
	mtc1 $s6, $f12
	cvt.s.w $f12, $f12
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBGTandLDL
	li $v0, 4
	syscall
AverageBPT:
	la $a0, AverageBPTMsg
	li $v0, 4
	syscall
	# Calculate the average for BPT
	beqz $s5, NonBPT
	mtc1 $s5, $f7
	cvt.s.w $f7, $f7
	div.s $f8, $f3, $f7
	div.s $f9, $f4, $f7
	mov.s $f12, $f8
	li $v0, 2
	syscall
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	mov.s $f12, $f9
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBPT
	li $v0, 4
	syscall
	j Done4
NonBPT:
	li $s6, 0
	mtc1 $s6, $f12
	cvt.s.w $f12, $f12
	li $v0, 2
	syscall
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	li $v0, 2
	syscall
	la $a0, MeasuringUnitBPT
	li $v0, 4
	syscall
Done4:
	j menu
######################################################## Update an existing test result ##################################################################	
UpdateResult:
	la $a0, ReadingIDMsg2	# message to read the patient's ID
	li $v0, 4
	syscall
	
	# Clear Line Buffer
	la $a0, lineBuffer
	li $t0, 0
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	# Read the ID number
	la $a0, lineBuffer
	li $a1, 20
	li $v0, 8
	syscall
# check if the input ID is valid or not
checkValidation5:
	la $a0, lineBuffer
	li $t1, 0	# store the number of digits of ID
traverse_loop5:
	lb $t2, 0($a0)
	beqz $t2, checkDigits5
	beq $t2, 10, checkDigits5
	blt $t2, 48, ErrorID5
	bgt $t2, 57, ErrorID5
	addi $t1, $t1, 1
	addiu $a0, $a0, 1
	j traverse_loop5
	
checkDigits5:
	bne $t1, 7, ErrorID5
	j converting5
ErrorID5: 
	la $a0, ErMsgID
	li $v0, 4
	syscall
	j UpdateResult

# convert the input ID into integer datatype
converting5:
	la $a0, lineBuffer
	li $t0, 0	# store the input ID in $t0
convertIntID5:
	lb $t1, 0($a0)
	beqz $t1, searchInIDArray5
	beq $t1, 10, searchInIDArray5
	subi $t1, $t1, '0'
	
	li $t2, 10
	
	mul $t0, $t0, $t2
	
	add $t0, $t0, $t1
	
	addiu $a0, $a0, 1
	j convertIntID5
	
# check if the input ID is exist in the Array	
# $t0 has the input ID
searchInIDArray5:
	la $a1, IDArray
	lw $t1, index	# store the last index we have reached in storing the data in the ID Array
	li $t2, 0	# store the initial index then traverse through the array
traverse_IDarray5:
	beq $t2, $t1, IDDoesNotExist5
	sll $t2, $t2, 2 
	add $a1, $a1, $t2
	lw $t3, 0($a1)
	la $a1, IDArray
	addi $t2, $t2, 1
	bne $t3, $t0, traverse_IDarray5

# ID Exist in the Array
IDExist5:
	j DetermineMedicalTests
IDDoesNotExist5:
	la $a0, IDnotExist
	li $v0, 4
	syscall
	j UpdateResult

DetermineMedicalTests:
	# $t0 has the ID number
	move $s0, $t0
	la $a2, IDArray
	lw $t0, index
	li $t1, 0	# store the actual index of the array
	li $t2, 0	# store the fake index of the array ([0], [1], [2], .....)
traverse_IDArray5:
	beq $t0, $t1, EndOfIDAyyar5
	sll $t1, $t1, 2
	add $a2, $a2, $t1
	lw $t3, 0($a2)
	la $a2, IDArray
	addi $t1, $t1, 1
	beq $s0, $t3, TestExistsHere5
	addi $t2, $t2, 1
	j traverse_IDArray5
	
TestExistsHere5:
	# $t2 has the fake index
	move $s1, $t2	# Save the fake index
	li $t3, 0	# reaching the actual index of the Test and store it here
	li $t4, 0	# reaching the actual index of the Test and store it here
# Find the Actual index of result array and name array and date array
calculateActualIndex5:
	beqz $s1, printTest5
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	sll $t3, $t3, 2
	sll $t4, $t4, 3
	subi $s1, $s1, 1
	j calculateActualIndex5
printTest5:
	# print medical test name
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t4
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare3             # Call the string comparison function
    	beq $v0, 1, NameIsBPT5        # If return is 1, name is valid
    	 	
################### The Test is not BPT
NameIsNotBPT5:	
	li $s7, 0
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	
	j CheckIfRequiredTest
	
NameIsBPT5:
	li $s7, 1
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall

CheckIfRequiredTest:
	la $a0, CheckUpdate
	li $v0, 4
	syscall
checkAnswer5:
	li $v0, 5
	syscall	
	beq $v0, 1, ChangeResult
	beq $v0, 2, Continue5
	
	la $a0, ErrorSelection
	li $v0, 4
	syscall
	j checkAnswer5
Continue5:	
	addi $t2, $t2, 1
	j traverse_IDArray5	
ChangeResult:
	beq $s7, 1, ChengeResultBPT
	la $a0, NewResultMsg
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	la $a0, TresultArray
	add $a0, $a0, $t4
	swc1 $f0, 0($a0)
	
	la $a0, ResultUpdated
	li $v0, 4
	syscall
	
	j menu
	
ChengeResultBPT:	
	la $a0, NewResultMsgSBP
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	mov.s $f1, $f0
	
	la $a0, NewResultMsgDBP
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	la $a2, TresultArray
	add $a2, $a2, $t4
	swc1 $f1, 0($a2)
	swc1 $f0, 4($a2)
	
	la $a0, ResultUpdated
	li $v0, 4
	syscall
	
	j menu
		
EndOfIDAyyar5:
	la $a0, EndOfTests
	li $v0, 4
	syscall
	j menu	
######################################################## Delete a test ##################################################################
DeleteTest:
	la $a0, ReadingIDMsg2	# message to read the patient's ID
	li $v0, 4
	syscall
	
	# Clear Line Buffer
	la $a0, lineBuffer
	li $t0, 0
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	# Read the ID number
	la $a0, lineBuffer
	li $a1, 20
	li $v0, 8
	syscall
# check if the input ID is valid or not
checkValidation6:
	la $a0, lineBuffer
	li $t1, 0	# store the number of digits of ID
traverse_loop6:
	lb $t2, 0($a0)
	beqz $t2, checkDigits6
	beq $t2, 10, checkDigits6
	blt $t2, 48, ErrorID6
	bgt $t2, 57, ErrorID6
	addi $t1, $t1, 1
	addiu $a0, $a0, 1
	j traverse_loop6
	
checkDigits6:
	bne $t1, 7, ErrorID6
	j converting6
ErrorID6: 
	la $a0, ErMsgID
	li $v0, 4
	syscall
	j DeleteTest

# convert the input ID into integer datatype
converting6:
	la $a0, lineBuffer
	li $t0, 0	# store the input ID in $t0
convertIntID6:
	lb $t1, 0($a0)
	beqz $t1, searchInIDArray6
	beq $t1, 10, searchInIDArray6
	subi $t1, $t1, '0'
	
	li $t2, 10
	
	mul $t0, $t0, $t2
	
	add $t0, $t0, $t1
	
	addiu $a0, $a0, 1
	j convertIntID6
	
# check if the input ID is exist in the Array	
# $t0 has the input ID
searchInIDArray6:
	la $a1, IDArray
	lw $t1, index	# store the last index we have reached in storing the data in the ID Array
	li $t2, 0	# store the initial index then traverse through the array
traverse_IDarray6:
	beq $t2, $t1, IDDoesNotExist6
	sll $t2, $t2, 2 
	add $a1, $a1, $t2
	lw $t3, 0($a1)
	la $a1, IDArray
	addi $t2, $t2, 1
	bne $t3, $t0, traverse_IDarray6

# ID Exist in the Array
IDExist6:
	j DetermineMedicalTests6
IDDoesNotExist6:
	la $a0, IDnotExist
	li $v0, 4
	syscall
	j DeleteTest

DetermineMedicalTests6:
	# $t0 has the ID number
	move $s0, $t0
	la $a2, IDArray
	lw $t0, index
	li $t1, 0	# store the actual index of the array
	li $t2, 0	# store the fake index of the array ([0], [1], [2], .....)
traverse_IDArray6:
	beq $t0, $t1, EndOfIDAyyar6
	sll $t1, $t1, 2
	add $a2, $a2, $t1
	lw $t3, 0($a2)
	la $a2, IDArray
	addi $t1, $t1, 1
	beq $s0, $t3, TestExistsHere6
	addi $t2, $t2, 1
	j traverse_IDArray6
	
TestExistsHere6:
	# $t2 has the fake index
	move $s1, $t2	# Save the fake index
	li $t3, 0	# reaching the actual index of the Test and store it here
	li $t4, 0	# reaching the actual index of the Test and store it here
# Find the Actual index of result array and name array and date array
calculateActualIndex6:
	beqz $s1, printTest6
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	sll $t3, $t3, 2
	sll $t4, $t4, 3
	subi $s1, $s1, 1
	j calculateActualIndex6
printTest6:
	# print medical test name
	la $a0, TNMP
	li $v0, 4
	syscall
	la $a1, TnameArray
	add $a0, $a1, $t3
	li $v0, 4
	syscall
	
	# print medical test date
	la $a0, TDMP
	li $v0, 4
	syscall
	la $a1, TdateArray
	add $a0, $a1, $t4
	li $v0, 4
	syscall
	
################## Check if the Test is BPT #########################
	la $a1, TnameArray
	add $a1, $a1, $t3
	
	la $a0, lineBuffer
	li $t5, 0
	sw $t5, 0($a0)
	sw $t5, 4($a0)
# store the name of Test in Line Buffer	
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	lb $t6, 0($a1)
	sb $t6, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	
	la $a1, lineBuffer
	la $a0, validName4             # Fourth valid test name
    	jal string_compare3             # Call the string comparison function
    	beq $v0, 1, NameIsBPT6        # If return is 1, name is valid
    	 	
################### The Test is not BPT
NameIsNotBPT6:	
	li $s7, 0
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	
	j CheckIfRequiredTest6
	
NameIsBPT6:
	li $s7, 1
	# print medical test result
	la $a0, TRMP
	li $v0, 4
	syscall
	# print SBP result
	la $a1, TresultArray
	add $a1, $a1, $t4
	lwc1 $f12, 0($a1)
	li $v0, 2
	syscall
	# print forward slash
	la $a0, ForwardSlash
	li $v0, 4
	syscall
	# print DBP result
	lwc1 $f12, 4($a1)
	li $v0, 2
	syscall

CheckIfRequiredTest6:
	la $a0, CheckDelete
	li $v0, 4
	syscall
checkAnswer6:
	li $v0, 5
	syscall	
	beq $v0, 1, Delete
	beq $v0, 2, Continue6
	
	la $a0, ErrorSelection
	li $v0, 4
	syscall
	j checkAnswer6
Continue6:	
	addi $t2, $t2, 1
	j traverse_IDArray6	
Delete:
	li $s5, 0
	mtc1 $s5, $f0
	cvt.s.w $f0, $f0
	la $a0, IDArray
	add $a0, $a0, $t3
	sw $s5, 0($a0)
	la $a0, TnameArray
	add $a0, $a0, $t3
	sw $s5, 0($a0)
	la $a0, TdateArray
	add $a0, $a0, $t4
	sw $s5, 0($a0)
	sw $s5, 4($a0)
	la $a0, TresultArray
	add $a0, $a0, $t4
	swc1 $f0, 0($a0)
	swc1 $f0, 4($a0)
	
	la $a0, TestDeleted
	li $v0, 4
	syscall
	
	j menu
EndOfIDAyyar6:
	la $a0, EndOfTests
	li $v0, 4
	syscall
	j menu
######################################################## Exitting the program ##################################################################	
ExitProgram:
	la $a0, OutputFileName
	li $a1, 1
	li $v0, 13
	syscall
	
	move $s7, $v0	# Save the output file descriptor in $s7
	la $a0, OutputBuffer
	li $s0, 0	# Save the current index for Tname and Id arrays
	li $s1, 0	# Save the current index for Tresult and Tdate arrays
	lw $s2, index	# store the last index in IDArray and TnameArray
	lw $s3, indexofTdate	# Store the last index in TdateArray and TresultArray
	li $s4, 10
	mtc1 $s4, $f1
	cvt.s.w $f1, $f1
	
	
	bgez $v0, SaveData
	j Exit
	
SaveData:
	beq $s0, $s2, EndOfArrays
	sll $s0, $s0, 2
	sll $s1, $s1, 3
	li $a1, 0
	la $a1, IDArray
	add $a1, $a1, $s0
	
	li $a2, 0
	la $a2, outputID
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
	addiu $a2, $a2, 6
	
	li $k0, 0	# register to determine if the medical test is BPT or not
	
	lw $t2, 0($a1)	# $t2 has the ID number
	beqz $t2, ReachTheID
	
	j Int_to_String
ReachTheID:
	addiu $s0, $s0, 1
	addiu $s1, $s1, 1
	j SaveData
	
	
Int_to_String:	
	div $t2, $t2, $s4
	mfhi $t3
	addiu $t3, $t3, '0'	# convert the digit into ASCII code
	sb $t3, 0($a2)
	beqz $t2, Output1
	subi $a2, $a2, 1
	j Int_to_String
	
Output1:
	la $a2, outputID
printIDIntoBuffer:
	lb $t2, 0($a2)
	beqz $t2, Output2
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $a2, $a2, 1
	j printIDIntoBuffer
Output2:
	li $t2, 58
	li $t3, 32
	sb $t2, 0($a0)	# Adding : to the output
	addiu $a0, $a0, 1
	sb $t3, 0($a0)	# Adding space " " to the output
	addiu $a0, $a0, 1
	
	la $a1, TnameArray
	add $a1, $a1, $s0
printNameIntoBuffer:
	lb $t2, 0($a1)
	beq $t2, 80, BPTMT
	beqz $t2, Output3
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	j printNameIntoBuffer
BPTMT:
	li $k0, 1	# to know that the Medical test is BPT
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	j printNameIntoBuffer
Output3:
	li $t2, 44
	li $t3, 32
	sb $t2, 0($a0)	# Adding , to the output
	addiu $a0, $a0, 1
	sb $t3, 0($a0)	# Adding space " " to the output
	addiu $a0, $a0, 1
	
	la $a1, TdateArray
	add $a1, $a1, $s1
printDateIntoBuffer:
	lb $t2, 0($a1)
	beqz $t2, Output4
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	j printDateIntoBuffer
		
Output4:
	li $t2, 44
	li $t3, 32
	sb $t2, 0($a0)	# Adding , to the output
	addiu $a0, $a0, 1
	sb $t3, 0($a0)	# Adding space " " to the output
	addiu $a0, $a0, 1
	
	la $a2, outputResult
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
	beqz $k0, NOTBPTMT
################## BPT Medical Test
# $k0 = 1
BPTMT7:
	la $a1, TresultArray
	add $a1, $a1, $s1
	lwc1 $f0, 0($a1)
	floor.w.s $f2, $f0
	mfc1 $t2, $f2
	mul.s $f0, $f0, $f1
	floor.w.s $f3, $f0
	mfc1 $t9, $f3
	div $t9, $t9, $s4
	mfhi $t3
	# $t2 has the integer part1
	# $t3 has the fractional part1
	lwc1 $f5, 4($a1)
	floor.w.s $f2, $f5
	mfc1 $t7, $f2
	mul.s $f5, $f5, $f1
	floor.w.s $f3, $f5
	mfc1 $t9, $f3
	div $t9, $t9, $s4
	mfhi $t8
	# $t7 has the integer part2
	# $t8 has the fractional part2
	la $a2, outputResult
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
convertIntPart8:
	div $t2, $t2, $s4
	mfhi $t4
	addiu $t4, $t4, 48
	sb $t4, 0($a2)
	addiu $a2, $a2, 1
	beqz $t2, Output8
	j convertIntPart8
		
Output8:
	sb $zero, 0($a2)
	la $a2, outputResult
adding1:
	lb $t2, 0($a2)
	beqz $t2, Output9
	addiu $a2, $a2, 1
	j adding1
Output9:
	subi $a2, $a2, 1
	la $t4, outputResult
printIntResultIntoBuffer2:
	lb $t2, 0($a2)
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	beq $t4, $a2, Output10
	subi $a2, $a2, 1
	j printIntResultIntoBuffer2
Output10:
	li $t2, 46
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $t3, $t3, 48
	sb $t3, 0($a0)
	addiu $a0, $a0, 1
	li $t2, 47
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	la $a2, outputResult
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
convertIntPart8_2:
	div $t7, $t7, $s4
	mfhi $t4
	addiu $t4, $t4, 48
	sb $t4, 0($a2)
	addiu $a2, $a2, 1
	beqz $t7, Output11
	j convertIntPart8_2
		
Output11:
	sb $zero, 0($a2)
	la $a2, outputResult
adding2:
	lb $t2, 0($a2)
	beqz $t2, Output12
	addiu $a2, $a2, 1
	j adding2
Output12:
	subi $a2, $a2, 1
	la $t4, outputResult
printIntResultIntoBuffer3:
	lb $t2, 0($a2)
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	beq $t4, $a2, Output13
	subi $a2, $a2, 1
	j printIntResultIntoBuffer3
Output13:
	li $t2, 46
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $t8, $t8, 48
	sb $t8, 0($a0)
	addiu $a0, $a0, 1
AddingNewLine2:
	li $t2, 10
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	
	li $t2, 0
	
	addiu $s0, $s0, 1
	addiu $s1, $s1, 1
	j SaveData
################## NOTBPT Medical Test
# $k0 = 0
NOTBPTMT:
	la $a1, TresultArray
	add $a1, $a1, $s1
	lwc1 $f0, 0($a1)
	floor.w.s $f2, $f0
	mfc1 $t2, $f2
	mul.s $f0, $f0, $f1
	floor.w.s $f3, $f0
	mfc1 $t9, $f3
	div $t9, $t9, $s4
	mfhi $t3
	# $t2 has the integer part
	# $t3 has the fractional part
	la $a2, outputResult
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
convertIntPart7:
	div $t2, $t2, $s4
	mfhi $t4
	addiu $t4, $t4, 48
	sb $t4, 0($a2)
	addiu $a2, $a2, 1
	beqz $t2, Output5
	j convertIntPart7
		
Output5:
	
	sb $zero, 0($a2)
	la $a2, outputResult
adding:
	lb $t2, 0($a2)
	beqz $t2, Output6
	addiu $a2, $a2, 1
	j adding
Output6:
	subi $a2, $a2, 1
	la $t4, outputResult
printIntResultIntoBuffer:
	lb $t2, 0($a2)
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	beq $t4, $a2, Output7
	subi $a2, $a2, 1
	j printIntResultIntoBuffer
Output7:
	li $t2, 46
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	addiu $t3, $t3, 48
	sb $t3, 0($a0)
	addiu $a0, $a0, 1
AddingNewLine:
	li $t2, 10
	sb $t2, 0($a0)
	addiu $a0, $a0, 1
	
	addiu $s0, $s0, 1
	addiu $s1, $s1, 1
	j SaveData

EndOfArrays:
	move $a0, $s7
	la $a1, OutputBuffer
	li $a2, 5000
	li $v0, 15
	syscall
	
Exit:	
	la $a0, ExittingProgram
	li $v0, 4
	syscall
	li $v0, 10		# Exit program
	syscall
	