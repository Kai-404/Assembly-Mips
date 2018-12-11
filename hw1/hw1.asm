
.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"

# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.
a_0_str: .asciiz "000"
a_1_str: .asciiz "001"
a_2_str: .asciiz "010"
a_3_str: .asciiz "011"
a_4_str: .asciiz "100"
a_5_str: .asciiz "101"
a_6_str: .asciiz "110"
a_7_str: .asciiz "111"

b_0_str: .asciiz "0000"
b_1_str: .asciiz "0001"
b_2_str: .asciiz "0010"
b_3_str: .asciiz "0011"
b_4_str: .asciiz "0100"
b_5_str: .asciiz "0101"
b_6_str: .asciiz "0110"
b_7_str: .asciiz "0111"
b_8_str: .asciiz "1000"
b_9_str: .asciiz "1001"
b_10_str: .asciiz "1010"
b_11_str: .asciiz "1011"
b_12_str: .asciiz "1100"
b_13_str: .asciiz "1101"
b_14_str: .asciiz "1110"
b_15_str: .asciiz "1111"

reversed_order: .byte 0
# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here
    
    
    move $s0, $a0
    
    lw $t0, addr_arg0
    lbu $t1, 0($t0)
    lbu $t2, 1($t0)
    
    bne $t1, 'F', checkIfIsC
    bnez $t2, INVALID_OPERATION
    bne $s0, 2, INVALID_ARGS
    j partThree
    
    checkIfIsC:

    bne $t1, 'C', checkIfIs2
    bnez $t2, INVALID_OPERATION
    bne $s0, 4, INVALID_ARGS
    j partFour
    
    checkIfIs2:

    bne $t1, '2', INVALID_OPERATION
    bnez $t2, INVALID_OPERATION
    bne $s0, 2, INVALID_ARGS
    j partTwo
    
    INVALID_OPERATION:
    la $a0, invalid_operation_error
    li $v0, 4
    syscall
    j exit

    INVALID_ARGS:
    la $a0, invalid_args_error
    li $v0, 4
    syscall
    j exit
    
############    
    partTwo:
    lw $t0, addr_arg1
    
    li $s1, 0 #counter
    
    
    lengthLoop: 
    

    lbu $t1, 0($t0)
    
    beq $t1, '\0', endLengthLoop
    
    addi $s1, $s1, 1 #counter+1
    
    beq $t1, '1', continueLoop
    
    beq $t1, '0', continueLoop
    

    j INVALID_ARGS
    
    continueLoop:
    addi $t0, $t0, 1 #nextByte 
    
    j lengthLoop
    
    endLengthLoop:
    bgt $s1, 32, INVALID_ARGS
 #################################
    
    lw $t0, addr_arg1
    lbu $t1, 0($t0)
    
    beq $t1, '1', negativeNum
    
    lbu $t1, 1($t0)
    beq $t1, '1', initiOne
    
    #start from 0
    li $t2, 0
    addi $t0, $t0, 2
    j binToDecLoop
    
    initiOne:
    li $t2, 1
    addi $t0, $t0, 2
    
    binToDecLoop:
    
    lbu $t1, 0($t0)
    beq $t1, '\0', result
    
    beq $t1,'1', plusOne
    
    sll $t2, $t2, 1
    addi $t2, $t2, 0
    
    addi $t0, $t0, 1
    j binToDecLoop
    
    plusOne:
    sll $t2, $t2, 1
    addi $t2, $t2, 1
    
    addi $t0, $t0, 1
    j binToDecLoop
    
    result:
    
    move $a0, $t2
    li $v0, 1
    syscall
    j exit
    
    negativeNum:
    
    lbu $t1, 1($t0)
    beq $t1, '0', initiOne2
    
    #start from 0
    li $t2, 0
    addi $t0, $t0, 2
    j binToDecLoop2
    
    initiOne2:
    li $t2, 1
    addi $t0, $t0, 2
    
    binToDecLoop2:
    
    lbu $t1, 0($t0)
    beq $t1, '\0', result2
    
    beq $t1,'0', plusOne2
    
    sll $t2, $t2, 1
    addi $t2, $t2, 0
    
    addi $t0, $t0, 1
    j binToDecLoop2
    
    plusOne2:
    sll $t2, $t2, 1
    addi $t2, $t2, 1
    
    addi $t0, $t0, 1
    j binToDecLoop2
    
    result2:
    li $t3, -1
    mul $t2, $t2, $t3
    addi $t2, $t2, -1
    move $a0, $t2
    li $v0, 1
    syscall
    
    j exit
######################### end of partTwo

    partThree:
    
    li $s0, 0
    
    lw $t0, addr_arg1
    
    argsCheckLoop:
    lbu $t1, 0($t0)
    
    beq $t1, '\0', checkIfIs8
    
    blt $t1, '0', INVALID_ARGS
    bgt $t1, 'F', INVALID_ARGS
    
    bgt $t1, '9', checkIfBiggerThanA
    
    j nextChar
    
    checkIfBiggerThanA:
    blt $t1, 'A', INVALID_ARGS
    
    nextChar:
    addi $s0, $s0, 1
    addi $t0, $t0, 1
    j argsCheckLoop
    
    checkIfIs8:
    bne $s0, 8, INVALID_ARGS
    
    lw $t0, addr_arg1
    lbu $t1, ($t0)
    andi $s7, $t1, 7
    blt $t1,'A', skipAddOne
    addi $s7, $s7, 1
    
    skipAddOne:
    sll $s7, $s7, 5
    
    
    lbu $t1, 1($t0)
    andi $t2, $t1, 15
    blt $t1,'A', skipAddNine
    addi $t2, $t2, 9
    
    skipAddNine:
    sll $t2, $t2, 1
    
    add $s7, $s7, $t2
    
    lbu $t1, 2($t0)
    blt $t1, '7', skipAddOn
    addi $s7, $s7, 1
    
    skipAddOn:
    
    beqz $s7, eIsZero
    beq $s7, 255, checkIfIsNan
    
    addi $s7, $s7, -127
    
    lbu $t1, ($t0)
    blt $t1, '8' isPos
    li $a0, -1
    li $v0,1
    syscall
    
    j keepPrint
    
    isPos:
    li $a0, 1
    li $v0,1
    syscall
    
    keepPrint:
    li $a0, '.'
    li $v0, 11
    syscall
    
    lbu $t1, 2($t0)
    andi $t2, $t1, 7
    blt $t1,'A', skipAddOne111
    addi $t2, $t2, 1
    
    skipAddOne111:
    
    bne $t2, 0, print1a
    la $a0, a_0_str
    li $v0, 4
    syscall
    j printRest
    
    print1a:
    bne $t2, 1, print2a
    la $a0, a_1_str
    li $v0, 4
    syscall
    j printRest
    
    print2a:
    bne $t2, 2, print3a
    la $a0, a_2_str
    li $v0, 4
    syscall
    j printRest
    
    print3a:
    bne $t2, 3, print4a
    la $a0, a_3_str
    li $v0, 4
    syscall
    j printRest
    
    print4a:
    bne $t2, 4, print5a
    la $a0, a_4_str
    li $v0, 4
    syscall
    j printRest
    
    print5a:
    bne $t2, 5, print6a
    la $a0, a_5_str
    li $v0, 4
    syscall
    j printRest
    
    print6a:
    bne $t2, 6, print7a
    la $a0, a_6_str
    li $v0, 4
    syscall
    j printRest
    
    print7a:
    la $a0, a_7_str
    li $v0, 4
    syscall
    
    printRest:
    
    addi $t0, $t0, 3
    
    printLoop:
    lbu $t2, 0($t0)
    beq $t2,'\0', print_floating_point_str
    addi $t0, $t0, 1
    
    bne $t2, '0', print1b
    la $a0, b_0_str
    li $v0, 4
    syscall
    j printLoop
    
    print1b:
    bne $t2, '1', print2b
    la $a0, b_1_str
    li $v0, 4
    syscall
    j printLoop
    
    print2b:
    bne $t2, '2', print3b
    la $a0, b_2_str
    li $v0, 4
    syscall
    j printLoop
    
    print3b:
    bne $t2, '3', print4b
    la $a0, b_3_str
    li $v0, 4
    syscall
    j printLoop
    
    print4b:
    bne $t2, '4', print5b
    la $a0, b_4_str
    li $v0, 4
    syscall
    j printLoop
    
    print5b:
    bne $t2, '5', print6b
    la $a0, b_5_str
    li $v0, 4
    syscall
    j printLoop
    
    print6b:
    bne $t2, '6', print7b
    la $a0, b_6_str
    li $v0, 4
    syscall
    j printLoop
    
    print7b:
    bne $t2, '7', print8b
    la $a0, b_7_str
    li $v0, 4
    syscall
    j printLoop
    
    print8b:
    bne $t2, '8', print9b
    la $a0, b_8_str
    li $v0, 4
    syscall
    j printLoop
    
    print9b:
    bne $t2, '9', printAb
    la $a0, b_9_str
    li $v0, 4
    syscall
    j printLoop
    
    printAb:
    bne $t2, 'A', printBb
    la $a0, b_10_str
    li $v0, 4
    syscall
    j printLoop
    
    printBb:
    bne $t2, 'B', printCb
    la $a0, b_11_str
    li $v0, 4
    syscall
    j printLoop
    
    printCb:
    bne $t2, 'C', printDb
    la $a0, b_12_str
    li $v0, 4
    syscall
    j printLoop
    
    printDb:
    bne $t2, 'D', printEb
    la $a0, b_13_str
    li $v0, 4
    syscall
    j printLoop
    
    printEb:
    bne $t2, 'E', printFb
    la $a0, b_14_str
    li $v0, 4
    syscall
    j printLoop
    
    printFb:
    la $a0, b_15_str
    li $v0, 4
    syscall
    j printLoop
    
    print_floating_point_str:
    la $a0,floating_point_str
    li $v0, 4
    syscall
    
    move $a0, $s7
    li $v0,1
    syscall
    
    la $a0, nl
    li $v0, 4
    syscall
    
    j exit
    
    checkIfIsNan:
    lbu $t1, 2($t0) 
    bne $t1, '0', check_If_Is8
    j check4Char
    
    check_If_Is8:
    bne $t1, '8', isNaN
    
    check4Char:
    lbu $t1, 3($t0)
    bne $t1, '0',isNaN
    
    check5Char:
    lbu $t1, 4($t0)
    bne $t1, '0',isNaN
    
    check6Char:
    lbu $t1, 5($t0)
    bne $t1, '0',isNaN
    
    check7Char:
    lbu $t1, 6($t0)
    bne $t1, '0',isNaN
    
    check8Char:
    lbu $t1, 7($t0)
    bne $t1, '0',isNaN
    j isInfinity
    
    
    isNaN:
    la $a0, NaN_str
    li $v0, 4
    syscall
    j exit
    
    eIsZero:
    la $a0, zero_str
    li $v0, 4
    syscall       
    j exit
    
    isInfinity:
    lbu $t1, ($t0)
    beq $t1, 'F', NegInfinity
    la $a0, pos_infinity_str
    li $v0, 4
    syscall       
    j exit
    
    NegInfinity:
    la $a0, neg_infinity_str
    li $v0, 4
    syscall       
    j exit
    
################################end of partThree    
    
    partFour:
    lw $t0, addr_arg2
    move $a0, $t0
    li $v0, 84
    syscall
    
    move $s3, $v0
    
    lw $t0, addr_arg3
    move $a0, $t0
    li $v0, 84
    syscall
    
    move $s4, $v0
    
    lw $t0, addr_arg1
    lbu $s7, ($t0)
    addi $s7, $s7, -48
    
    bge $s7, $s3, INVALID_ARGS
    
    convertToDecLoop:
    addi $t0, $t0, 1
    
    
    lbu $t1, ($t0)
    
    beq $t1,'\0', nextStep
    
    addi $t1, $t1, -48
    bge $t1, $s3, INVALID_ARGS
    
    mul $s7, $s7, $s3
    add $s7, $s7, $t1
    
    j convertToDecLoop
    
    nextStep:
    
    beqz $s7, printZero
    la $t0, reversed_order
    li $s6, 0 #length counter
    
    convertBase:
    
    divu $s7, $s4
    mflo $s7
    mfhi $t4
    
    sb $t4, ($t0)
    addi $s6, $s6, 1
    beqz $s7, printReverse
    
    addi $t0, $t0, 1
    
    j convertBase
    
    
    
    
    printReverse:
    
    la $t0, reversed_order  
    add $t0, $t0, $s6
    addi $t0, $t0, -1
    
    printNumLoop:
    beqz $s6, exit
    
    lbu $a0, ($t0)
    li $v0, 1
    syscall
    
    addi $s6, $s6, -1
    addi $t0, $t0, -1
    
    j printNumLoop
    
    
    printZero:
    move $a0, $0
    li $v0, 1
    syscall
    
    j exit

exit:
    li $v0, 10   # terminate program
    syscall
