
#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
get_adfgvx_coords:
	
	bltz $a0, part1Error
	bgt $a0, 5, part1Error
	bltz $a1, part1Error
	bgt $a1, 5, part1Error
	
	bnez, $a0, checkD1
	li $v0, 'A'
	j check2nd
	
	checkD1:
	bne $a0, 1, checkF1
	li $v0, 'D'
	j check2nd
	
	checkF1:
	bne $a0, 2, checkG1
	li $v0, 'F'
	j check2nd
	
	checkG1:
	bne $a0, 3, checkV1
	li $v0, 'G'
	j check2nd
	
	checkV1:
	bne $a0, 4, checkX1
	li $v0, 'V'
	j check2nd
	
	checkX1:
	li $v0, 'X'
	
	
	check2nd:
	
	bnez, $a1, checkD2
	li $v1, 'A'
	j part1Exit
	
	checkD2:
	bne $a1, 1, checkF2
	li $v1, 'D'
	j part1Exit
	
	checkF2:
	bne $a1, 2, checkG2
	li $v1, 'F'
	j part1Exit
	
	checkG2:
	bne $a1, 3, checkV2
	li $v1, 'G'
	j part1Exit
	
	checkV2:
	bne $a1, 4, checkX2
	li $v1, 'V'
	j part1Exit
	
	checkX2:
	li $v1, 'X'
	j part1Exit
	
	part1Error:
	li $v0, -1
	li $v1, -1
	
	j part1Exit
	
	part1Exit:

	jr $ra

# Part II
search_adfgvx_grid:

	move $t0, $a0
	
	li $t1,0
	
	part2SearchLoop:
	lb $t2, ($t0)
	beq $a1,$t2, findPart2
	
	addi $t1, $t1, 1
	beq $t1, 36, notFindPart2
	addi $t0, $t0, 1
	j part2SearchLoop
	
	
	notFindPart2:
	li $v0, -1
	li $v1, -1
	j part2Exit2
	
	findPart2:
	
	li $t3, 6
	div $t1, $t3
	
	mfhi $v1
	mflo $v0
		
	part2Exit2:
	jr $ra

# Part III
map_plaintext:
	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	mapLoop:
	move $a0, $s0
	lb $a1, ($s1)
	
	beq $a1, '\0', doneMap
	
	jal search_adfgvx_grid
	
	move $a0, $v0
	move $a1, $v1
	
	jal get_adfgvx_coords
	
	sb $v0, ($s2)
	sb $v1, 1($s2)
	
	addi $s1, $s1, 1
	addi $s2, $s2, 2
	
	j mapLoop
	
	doneMap:
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

# Part IV
swap_matrix_columns:

	blez $a1, swapError
	blez $a2, swapError
	bltz $a3, swapError
	bge $a3, $a2, swapError
	
	lw $t0, ($sp)
	bltz $t0, swapError
	bge $t0, $a2, swapError
		
	li $t1, 0 #row pointer
	
	swapLoop:
	mul $t2, $a2, $t1
	
	add $t3, $t2, $a3
	add $t4, $t2, $t0
	
	add $t3, $t3, $a0 # address 1
	add $t4, $t4, $a0 # address 2
	
	lb $t5, ($t3)
	lb $t6, ($t4)
	
	sb $t6, ($t3)
	sb $t5, ($t4)
	
	addi $t1, $t1, 1
	beq $t1, $a1, swapDone

	j swapLoop
	
	
	swapError:
	li $v0, -1
	j exitSwap
	
	swapDone:
	li $v0, 0
	exitSwap:
	jr $ra

# Part V
key_sort_matrix:

	lw $t0, ($sp)
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	
	move $s0, $a3 #key array
	move $s5, $a3
	move $s1, $t0 #element size
	
	li $s2, 0 #i
		
	Iloop:
	bge $s2, $a2, doneSort
	li $s3, 0 #j
	sub $s4, $a2, $s2 #n-i
	addi $s4, $s4, -1 #n-i-1
	move $s0, $s5
	
	Jloop:

	beq $s1, 4, elementSize4
	
	
	bge $s3, $s4, nextI
	
	lb $t0, ($s0)
	lb $t1, 1($s0)
	ble $t0, $t1, nextJ1
	sb $t1, ($s0)
	sb $t0, 1($s0)
	
	move $a3, $s3
	addi $t2, $a3, 1
	
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	jal swap_matrix_columns
	addi $sp, $sp, 4
	
	nextJ1:
	addi $s0, $s0, 1
	addi $s3, $s3, 1
	j Jloop
	
	
	elementSize4:
	
	bge $s3, $s4, nextI
	
	lw $t0, ($s0)
	lw $t1, 4($s0)
	ble $t0, $t1, nextJ4
	sw $t1, ($s0)
	sw $t0, 4($s0)
	
	move $a3, $s3
	addi $t2, $a3, 1
	
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	jal swap_matrix_columns
	addi $sp, $sp, 4
	
	nextJ4:
	addi $s0, $s0, 4
	addi $s3, $s3, 1
	j Jloop
	
	nextI:
	addi $s2, $s2, 1
	j Iloop
	
	doneSort:
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra

# Part IV
transpose:
	
	
	blez $a2, transError
	blez $a3, transError
	
	move $t4, $a1
	
	li $t1, 0 #col pointer
	
	colLoop:
	li $t0, 0 #row pointer
	
	rowLoop:

	mul $t2, $t0, $a3
	
	add $t2, $t2, $a0
	
	add $t2, $t2, $t1
	
	lb $t3, ($t2)
	sb $t3, ($t4)
	
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	beq $a2, $t0, nextCol
	
	j rowLoop
	
	
	nextCol:
	addi $t1, $t1, 1
	beq $a3, $t1, transDone
	j colLoop
	
	
	transDone:
	li $v0, 0
	j transExit
	
	
	transError:
	li $v0, -1
	
	transExit:

	jr $ra

# Part VII
encrypt:
	
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	
	move $t2, $a1
	li $t0, 0
	plaintextLoop:

	lb $t1, ($t2)
	beq  $t1, '\0', plaintextLengthDone
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j plaintextLoop
	
	plaintextLengthDone:
	move $s0, $t0
	
	
	move $t2, $a2
	li $t0, 0
	keywordLengthLoop:

	lb $t1, ($t2)
	beq  $t1, '\0', keywordLengthDone
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j keywordLengthLoop
	
	keywordLengthDone:
	move $s1, $t0 #num_cols
	
	li $t1, 2
	mul $t0,$s0, $t1
	div $t0, $s1
	mflo $s2	#num_rows
	mfhi $t1
	beqz $t1, dontAddOne
	addi $s2, $s2, 1
	
	dontAddOne:
	move $s4, $a0 # grid address OG a0
	mul $a0, $s2, $s1
	li $v0, 9
	syscall
	
	move $s3, $v0
	
	move $t0, $s3 # heap ciphertext array
	li $t1, 0
	li $t2, '*'
	
	fillLoop:
	sb $t2, ($t0)
	
	addi $t1, $t1,1
	beq $t1, $a0, doneFill
	addi $t0, $t0, 1
	j fillLoop
	
	doneFill:
	
	move $t0, $a3
	add $t0, $t0, $t1	
	sb $0, ($t0) #add null-terminator
	
	move $s5, $a1	#plaintext
	move $s6, $a2	#keyword
	move $s7, $a3	#ciphertext
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s3
	
	jal map_plaintext
	
	move $a0, $a2
	move $a1, $s2
	move $a2, $s1
	move $a3, $s6
	addi $sp, $sp, -4
	li $t0, 1
	sw $t0, 0($sp)
	jal key_sort_matrix
	addi $sp, $sp, 4
	
	move $a1, $s7
	move $a2, $s2
	move $a3, $s1
	
	jal transpose
	
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	jr $ra

# Part VIII
lookup_char:
	
	beq $a1, 'A', checkColChar
	beq $a1, 'D', checkColChar
	beq $a1, 'F', checkColChar
	beq $a1, 'G', checkColChar
	beq $a1, 'V', checkColChar
	beq $a1, 'X', checkColChar	
	j lookUpError
	
	checkColChar:
	
	beq $a2, 'A', bothChecked
	beq $a2, 'D', bothChecked
	beq $a2, 'F', bothChecked
	beq $a2, 'G', bothChecked
	beq $a2, 'V', bothChecked
	beq $a2, 'X', bothChecked
	j lookUpError
	
	bothChecked:
	
	bne $a1, 'A', ifRowIsD
	li $t0, 0
	j findColNum
	
	ifRowIsD:
	bne $a1, 'D', ifRowIsF
	li $t0, 1
	j findColNum
	
	ifRowIsF:
	bne $a1, 'F', ifRowIsG
	li $t0, 2
	j findColNum
	
	ifRowIsG:
	bne $a1, 'G', ifRowIsV
	li $t0, 3
	j findColNum
	
	ifRowIsV:
	bne $a1, 'V', rowIsX
	li $t0, 4
	j findColNum
	
	rowIsX:
	li $t0, 5
	
	
	
	findColNum:
	
	bne $a2, 'A', ifColIsD
	li $t1, 0
	j lookUpChar
	
	ifColIsD:
	bne $a2, 'D', ifColIsF
	li $t1, 1
	j lookUpChar
	
	ifColIsF:
	bne $a2, 'F', ifColIsG
	li $t1, 2
	j lookUpChar
	
	ifColIsG:
	bne $a2, 'G', ifColIsV
	li $t1, 3
	j lookUpChar
	
	ifColIsV:
	bne $a2, 'V', colIsX
	li $t1, 4
	j lookUpChar
	
	colIsX:
	li $t1, 5
	
	lookUpChar:
	
	li $t2, 6
	mul $t0, $t0, $t2
	add $t0, $t0, $t1
	add $t0, $a0, $t0
	lb $v1, ($t0)
	li $v0, 0
	j lookUpExit
	
	lookUpError:
	li $v0, -1
	li $v1, -1
	
	lookUpExit:
	
	jr $ra

# Part IX
string_sort:
	
	li $t0, 0 #length
	move $t9, $a0
	
	sortLengthLoop:
	lb $t2, ($t9)
	beq $t2, '\0', goSorting
	addi $t0, $t0, 1
	addi $t9, $t9, 1
	j sortLengthLoop
	
	goSorting:
	
	
	li $t1, 0 #i
		
	Iloop9:
	bge $t1, $t0, doneSort9
	li $t2, 0 #j
	sub $t3, $t0, $t1 #n-i
	addi $t3, $t3, -1 #n-i-1
	move $t9, $a0
	
	Jloop9:

	bge $t2, $t3, nextI9
	
	lb $t7, ($t9)
	lb $t8, 1($t9)
	ble $t7, $t8, nextJ9
	sb $t8, ($t9)
	sb $t7, 1($t9)
	
	
	nextJ9:
	addi $t9, $t9, 1
	addi $t2, $t2, 1
	j Jloop9
	
	nextI9:
	addi $t1, $t1, 1
	j Iloop9
	
	
	doneSort9:
	jr $ra

# Part X
decrypt:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	
	move $a0, $s2
	jal getLength
	move $a0, $v0
	li $v0, 9
	syscall
	
	move $s4, $v0 #heap_keyword address
	
	
	move $t1, $s2
	
	copyLoop:
	lb $t2, ($t1)
	beq $t2,'\0', doneCopy
	sb $t2, ($v0)
	addi $t1, $t1, 1
	addi $v0, $v0, 1
	j copyLoop
	
	doneCopy:
	
	move $a0, $s4
	jal string_sort
	
	move $a0, $s2
	jal getLength
	move $a0, $v0
	li $t0, 4
	mul $a0, $a0, $t0
	li $v0, 9
	syscall
	
	move $s5, $v0 #heap_keyword_indices  address
	
	move $a0, $s2
	jal getLength
	
	move $t9, $v0
	
	li $t8 ,0 #i
	move $t7, $s4
	move $t6, $s5
	
	fillIndicesLoop:
	bge $t8, $t9, doneFillIndices
	
	lb $a1, ($t7)
	move $a0, $s2
	jal indexOf
	
	sw $v0, ($t6)
	
	addi $t8, $t8, 1
	addi $t7, $t7, 1
	addi $t6, $t6, 4
	j fillIndicesLoop
	
	doneFillIndices:
	
	move $a0, $s2
	jal getLength
	move $s6, $v0, # num of rows
	
	move $a0, $s1
	jal getLength
	
	div $v0, $s6
	
	mflo $s7  #num of cols
	
	mul $a0, $s6, $s7
	li $v0, 9
	syscall
	
	move $a1, $v0
	move $a0, $s1
	move $a2, $s6
	move $a3, $s7
	
	jal transpose
	
	move $a0, $a1
	move $a1, $s7
	move $a2, $s6
	move $a3, $s5
	
	addi $sp, $sp, -4
	li $t0, 4
	sw $t0, 0($sp)
	jal key_sort_matrix
	addi $sp, $sp, 4
	
	move $t9, $a0
	
	decodeLoop:
	lb $a1, ($t9)
	beq $a1,'*', finalDone
	beq $a1,'\0', finalDone
	lb $a2, 1($t9)
	move $a0, $s0
	jal lookup_char
	
	sb $v1, ($s3)
	
	addi $t9, $t9 ,2
	addi $s3, $s3, 1
	
	j decodeLoop
	
	
	finalDone:
	sb $0, ($s3)
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	jr $ra

	
getLength:
	
	# $a0 = address of string
	# $v0 = length
	
	
	li $v0, 0 #length
	
	myLengthLoop:
	lb $t0, ($a0)
	beq $t0, '\0', returnLength
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j myLengthLoop
	
	returnLength:
	
	jr $ra

indexOf:
	# $a0 = address of string
	# $a1 = char
	# v0 = index
	
	li $v0, 0 # index
	
	findIndexLoop:
	lb $t0, ($a0)
	beq $t0, $a1, returnIndex
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j findIndexLoop
	
	returnIndex:
	
	jr $ra
	
	
	

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
