

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

### Part I ###
index_of_car:
	
		
	blez $a1, errorIndexOfCar
	bltz $a2, errorIndexOfCar
	bge $a2, $a1, errorIndexOfCar
	blt $a3, 1885, errorIndexOfCar
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	sll $t3, $a2, 4
	
	add $t0, $t0, $t3
	
	carIndexLoop:
	addi $t2, $t2, 1
	lh $t4, 12($t0)
	beq $t4, $a3, findCarIndex
	
	beq $t2, $t1, errorIndexOfCar
	
	addi $t0, $t0, 16
	j carIndexLoop
	
	findCarIndex:
	addi $t2, $t2, -1
	move $v0, $t2
	
	j doneIndexOfCar
	
	errorIndexOfCar: li $v0, -1
	
	doneIndexOfCar: jr $ra
	

### Part II ###
strcmp:
	
	move $t0, $a0
	move $t1, $a1
	
	lbu $t9, ($t0)
	bne $t9, '\0', firstNotEmpty
	
	
	li $t7,0
	
	secondStringLengthLoop:
	
	lbu $t8, ($t1)
	beq $t8, '\0', secondStringLength
	addi $t7, $t7, 1
	addi $t1, $t1, 1
	
	j secondStringLengthLoop
	
	secondStringLength:
	sub $v0,$0, $t7
	
	j doneStrcmp
	
	firstNotEmpty:
	lbu $t8, ($t1)
	bne $t8, '\0', secondNotEmpty
	
	li $t7,0
	
	firstStringLengthLoop:
	
	lbu $t9, ($t0)
	beq $t9, '\0', firstStringLength
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	
	j firstStringLengthLoop
	
	firstStringLength:
	move $v0, $t7
	
	j doneStrcmp
	
	
	secondNotEmpty:
	
	lbu $t2, ($t0)
	lbu $t3, ($t1)
	
	bne $t2, $t3, mismatch
	
	beq $t2, '\0', identical
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j secondNotEmpty

	
	mismatch:
	sub $v0, $t2, $t3
	j doneStrcmp
	
	identical: li $v0, 0
	doneStrcmp: jr $ra


### Part III ###
memcpy:
	blez $a2, cpyError
	
	move $t0, $a0
	move $t1, $a1
	
	li $t9,0
	
	cpyLoop:
	beq $t9, $a2, cpySuccess
	
	lb $t2,($t0)
	sb $t2,($t1)
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t9, $t9, 1
	
	j cpyLoop
	
	cpySuccess:li $v0, 0
	j cpyDone
	
	cpyError: li $v0, -1

	cpyDone: jr $ra


### Part IV ###
insert_car:
	
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	bltz $a1, insertError
	bltz $a3, insertError
	bgt $a3, $a1, insertError
	
	
	sub $s4, $a1, $s3  #amount to shift
	
	sll $t0, $s1, 4
	
	add $a1, $s0, $t0
	addi $a0, $a1, -16
	
	
	shiftLoop:
	beqz $s4, doneShift
	
	li $a2, 16
	jal memcpy
	
	addi $a1, $a1, -16
	addi $a0, $a0, -16
	addi $s4, $s4, -1
	
	j shiftLoop
	
	
	doneShift:
	
	sll $s3, $s3, 4
	add $a1, $s0, $s3
	move $a0, $s2,
	li $a2, 16
	jal memcpy
	
	j insertDone
	
	
	insertError: li $a0, -1
	
	
	insertDone:
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra
	

### Part V ###
most_damaged:
	
	blez $a2, damageError
	blez $a3, damageError
	
	li $v0, 0 #current high index
	li $v1, 0 #current high price 
	

	li $t0, 0 #car index point
	
	move $t1, $a0 #car array address
	move $t2, $a1 #repair array address
	
	nextDamageCar:
	
	li $t5, 0 #car repair price temp
	li $t6, 0 #car repair array pointer
	CarRepairLoop:
	
	lw $t3, ($t2)
	beq $t1, $t3, findCarRepair
	
	j nextCarRepair
	
	findCarRepair:
	lh $t4, 8($t2)
	add $t5, $t5, $t4
	
	nextCarRepair:
	addi $t2, $t2, 12
	addi $t6, $t6, 1
	beq $t6, $a3, camparePrice
	
	j CarRepairLoop
	
	camparePrice:
	ble $t5, $v1, notUpdate
	
	move $v1, $t5
	move $v0, $t0
	
	notUpdate:
	move $t2, $a1
	addi $t0, $t0, 1
	beq $t0, $a2, damageDone
	addi $t1, $t1, 16
	j nextDamageCar
	
	damageError:
	li $v0, -1
	li $v1, -1
	
	damageDone: jr $ra


### Part VI ###
sort:


	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	blez $a1, sortError
	
	move $s0, $a0
	addi $s1, $a1, -1 #length -1
	
	li $v0, -1 # 0=sorted, -1 = !sorted
	
	sortLoop:
	beqz $v0, sortDone
	
	li $v0, 0 #set to ture
	
	
	addi $s2, $s0, 16
	addi $s4, $s2, 16
	li $s3, 1 #pointer
	
	sortOdd:
	bge $s3, $s1, sortEven
	
	lh $t0, 12($s2)
	lh $t1, 12($s4)
	
	ble $t0, $t1, noSwapOdd
	
	addi $sp, $sp, -16
	
	move $a0, $s2
	move $a1, $sp
	li $a2, 16
	jal memcpy
	
	
	move $a0, $s4
	move $a1, $s2
	li $a2, 16
	jal memcpy
	
	move $a0, $sp
	move $a1, $s4
	li $a2, 16
	jal memcpy
	
	addi $sp, $sp, 16
	
	li $v0, -1
	
	
	noSwapOdd:
	
	addi $s3, $s3, 2
	addi $s2, $s2, 32
	addi $s4, $s4, 32
	j sortOdd
	
	
	sortEven:
	
	
	move $s2, $s0
	addi $s4, $s2, 16
	li $s3, 0 #pointer
	
	sortEvenLoop:
	bge $s3, $s1, sortLoop
	
	lh $t0, 12($s2)
	lh $t1, 12($s4)
	
	ble $t0, $t1, noSwapEven
	
	addi $sp, $sp, -16
	
	move $a0, $s2
	move $a1, $sp
	li $a2, 16
	jal memcpy
	
	
	move $a0, $s4
	move $a1, $s2
	li $a2, 16
	jal memcpy
	
	move $a0, $sp
	move $a1, $s4
	li $a2, 16
	jal memcpy
	
	addi $sp, $sp, 16
	
	li $v0, -1
	
	
	noSwapEven:
	
	addi $s3, $s3, 2
	addi $s2, $s2, 32
	addi $s4, $s4, 32
	j sortEvenLoop


	sortError:
	li $v0, -1
	
	sortDone:
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr $ra


### Part VII ###
most_popular_feature:
	blez  $a1, featureError
	blt $a2, 1, featureError
	bgt $a2, 15, featureError
	
	li $t0, 0 # convertible count
	li $t1, 0 # hybride count
	li $t2, 0 # windows count
	li $t3, 0 # GPS count
	
	li $t4, 0 #car index counter
	
	
	carFeatureLoop:
	lb $t9, 14($a0)
	addi $t4, $t4, 1
	
	andi $t8, $t9, 1
	bne $t8, 1, ifHybride
	addi $t0, $t0, 1
	
	ifHybride:
	andi $t8, $t9, 2
	bne $t8, 2, ifWindows
	addi $t1, $t1, 1
	
	ifWindows:
	andi $t8, $t9, 4
	bne $t8, 4, ifGps
	addi $t2, $t2, 1
	
	ifGps:
	andi $t8, $t9, 8
	bne $t8, 8, countNextCar
	addi $t3, $t3, 1
	
	countNextCar:
	
	
	beq $t4, $a1, countDone
	addi $a0, $a0, 16
	
	j carFeatureLoop
	
	countDone:
	
	li $v0,0 #current most popular
	li $t5,0 #how popular
	
	andi $t6, $a2, 8
	beqz $t6,  notConsiderGPS
	
	ble $t3, $t5, notConsiderGPS
	move $t5, $t3
	li $v0, 8
	
	notConsiderGPS:
	
	andi $t6, $a2, 4
	beqz $t6,  notConsiderWindows
	
	ble $t3, $t5, notConsiderWindows
	move $t5, $t3
	li $v0, 4
	
	
	notConsiderWindows:
	andi $t6, $a2, 2
	beqz $t6,  notConsiderHybrids
	
	ble $t3, $t5, notConsiderHybrids
	move $t5, $t3
	li $v0, 2
	
	notConsiderHybrids:
	andi $t6, $a2, 1
	beqz $t6,  checkIfNoFav
	
	ble $t3, $t5, checkIfNoFav
	move $t5, $t3
	li $v0, 1
	
	checkIfNoFav:
	bnez $t5, featureDone
	
	
	
	featureError:
	li $v0, -1
	
	featureDone:
	jr $ra
	

### Optional function: not required for the assignment ###
transliterate:
	#a0, char
	#a1, transliterate_str
	#v0, transliterate
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal index_of
	
	
	move $t0, $v0
	li $t1, 10
	div $t0, $t1
	mfhi $v0
	

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


### Optional function: not required for the assignment ###
char_at:
	#a0, vin
	#a1, char index
	#v0, return char at index a1
	
	add $a0, $a0, $a1
	lb $v0, ($a0)

	jr $ra


### Optional function: not required for the assignment ###
index_of:
	#a0, char
	#a1, transliterate_str
	#v0, return char index in transliterate_str
	
	
	
	li $v0, 0
	indexOfCharLoop:
	lb $t9, ($a1)
	beq $t9,$a0, find
	
	addi $a1, $a1, 1
	addi $v0, $v0, 1
	j indexOfCharLoop
					
	find:
		
	jr $ra


### Part VIII ###
compute_check_digit:
	
	
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	li $s4, 0 #sum
	li $s5, 0 # i
	
	forLoop:
	bge $s5, 17, finally
	
	move $a0, $s0
	move $a1, $s5
	
	jal char_at
	
	move $a0, $v0
	move $a1, $s3
	
	jal transliterate
	
	move $s6, $v0
	
	move $a0, $s2
	move $a1, $s5
	jal char_at
	
	move $a0, $v0
	move $a1, $s1
	jal index_of
	
	mul $s6, $s6, $v0
	
	add $s4, $s4, $s6
	
	addi $s5, $s5, 1
	
	j forLoop
	
	finally:
	
	li $t0, 11
	div $s4, $t0
	
	mfhi $a1
	move $a0, $s1
	
	jal char_at
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra	

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
