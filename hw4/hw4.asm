
#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
init_game:
	
	move $s0, $a0 #file name address
	move $s1, $a1 #map pointer
	move $s2, $a2 #player pointer
	
	li $a0, 1
	li $v0, 9
	syscall
	move $s3, $v0 # address of 1 byte temp buffer
	
	move $a0, $s0   
	li $a1, 0        # Open for read
	li $a2, 0        
	li $v0, 13 
	syscall
	bltz $v0, init_error          
	move $s4, $v0      # save the file descriptor 
	
	move $a0, $s4      
	move $a1, $s3 
	li $a2, 1       
	li $v0, 14 
	syscall           
	bltz $v0, init_error 
#################################### number of rows:	
	lb $t0, ($s3)
	addi $t0, $t0, -48
	li $t1, 10
	mul $t0, $t0, $t1
	
	li $v0, 14 
	syscall
	bltz $v0, init_error
	
	lb $t1, ($s3)
	addi $t1, $t1, -48
	
	add $t0, $t0, $t1
	
	sb $t0, ($s1)
	addi $s1, $s1, 1
	move $s5, $t0 #save num_rows
#################################### number of cols:
	li $v0, 14 
	syscall           
	bltz $v0, init_error 
	
	li $v0, 14 
	syscall           
	bltz $v0, init_error 
	
	lb $t0, ($s3)
	addi $t0, $t0, -48
	li $t1, 10
	mul $t0, $t0, $t1
	
	li $v0, 14 
	syscall	
	bltz $v0, init_error
	
	lb $t1, ($s3)
	addi $t1, $t1, -48
	
	add $t0, $t0, $t1
	  
	sb $t0, ($s1)
	addi $s1, $s1, 1
	move $s6, $t0 #save num_cols
	
################################# start	read map

	mul $t0, $s5, $s6
	addi $t0, $t0, -1 # total num of cells
	
	li $t1, 0 #cell counter
	
	map_load_loop:
	
	li $v0, 14 
	syscall	
	bltz $v0, init_error
	lb $t2, ($s3)
	
	beq $t2, '\n', map_load_loop
	
	bne $t2, '@', notHero
	
	div $t1, $s6
	mfhi $t3
	sb $t3, 1($s2)
	mflo $t3
	sb $t3, ($s2)
	
	notHero:
	addi $t2, $t2, 128
	sb $t2, ($s1)
	

	beq $t1, $t0, map_loaded
	addi $t1, $t1, 1
	addi $s1, $s1, 1
	
	j map_load_loop
	
	map_loaded:
	
	li $v0, 14 
	syscall           
	bltz $v0, init_error 
	
	li $v0, 14 
	syscall           
	bltz $v0, init_error 
	
	lb $t0, ($s3)
	addi $t0, $t0, -48
	li $t1, 10
	mul $t0, $t0, $t1
	
	li $v0, 14 
	syscall	
	bltz $v0, init_error
	
	lb $t1, ($s3)
	addi $t1, $t1, -48
	
	add $t0, $t0, $t1
	  
	sb $t0, 2($s2) #health
	
	sb $0, 3($s2) #coin
	
	
	move $a0, $s4
	li $v0, 16
	syscall
	
	li $v0, 0
	j init_exit
	
	
	init_error:
	move $a0, $s4
	li $v0, 16
	
	
	li $v0, -1
	j init_exit
	
	
	init_exit:
	
jr $ra


# Part II
is_valid_cell:

	bltz $a1, invalid_cell
	bltz $a2, invalid_cell
	
	lb $t0, ($a0)
	bge $a1, $t0, invalid_cell
	
	lb $t0, 1($a0)
	bge $a2, $t0, invalid_cell
	
	j valid_cell
	
	invalid_cell:
	li $v0, -1
	
	j part2_exit	
	
	valid_cell:
	li $v0, 0
	
	part2_exit:
jr $ra


# Part III
get_cell:

	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal is_valid_cell
	beq $v0, -1, get_cell_error
	
	lb $t0, ($a0)
	lb $t1, 1($a0)
	
	mul $t1, $t1, $a1
	add $t1, $t1, $a2
	
	addi $a0, $a0, 2
	add $a0, $a0, $t1
	
	lbu $v0, ($a0)
	
	
	get_cell_error:
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
jr $ra


# Part IV
set_cell:

	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	jal is_valid_cell
	beq $v0, -1, set_cell_error
	
	lb $t0, ($a0)
	lb $t1, 1($a0)
	
	mul $t1, $t1, $a1
	add $t1, $t1, $a2
	
	addi $a0, $a0, 2
	add $a0, $a0, $t1
	
	sb $a3, ($a0)
	li $v0, 0
	
	set_cell_error:
	
	lw $ra, ($sp)
	addi $sp, $sp, 4

jr $ra


# Part V
reveal_area:

	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, -1
	
	jal is_valid_cell
	
	beq $v0, -1, up_cell
	
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, -1
	
	jal get_cell
	
	blt $v0, 128, up_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, -1
	
	jal set_cell
	
	##
	up_cell:
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 0
	
	jal is_valid_cell
	
	beq $v0, -1, up_right_cell
	
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 0
	
	jal get_cell
	
	blt $v0, 128, up_right_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 0
	
	jal set_cell
	
	
	##
	up_right_cell:
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 1
	
	jal is_valid_cell
	
	beq $v0, -1, left_cell
	
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 1
	
	jal get_cell
	
	blt $v0, 128, left_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, -1
	addi $a2, $s2, 1
	
	jal set_cell
	
	
	##
	left_cell:
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, -1
	
	jal is_valid_cell
	
	beq $v0, -1, it_self_cell
	
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, -1
	
	jal get_cell
	
	blt $v0, 128, it_self_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, -1
	
	jal set_cell
	
	##
	it_self_cell:
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	
	jal is_valid_cell
	
	beq $v0, -1, right_cell
	
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	
	jal get_cell
	
	blt $v0, 128, right_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	
	jal set_cell
	
	
	##
	right_cell:
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 1
	
	jal is_valid_cell
	
	beq $v0, -1, down_left_cell
	
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 1
	
	jal get_cell
	
	blt $v0, 128, down_left_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 0
	addi $a2, $s2, 1
	
	jal set_cell
	
	##
	down_left_cell:
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, -1
	
	jal is_valid_cell
	
	beq $v0, -1, down_cell
	
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, -1
	
	jal get_cell
	
	blt $v0, 128, down_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, -1
	
	jal set_cell
	
	##
	down_cell:
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 0
	
	jal is_valid_cell
	
	beq $v0, -1, down_right_cell
	
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 0
	
	jal get_cell
	
	blt $v0, 128, down_right_cell
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 0
	
	jal set_cell
	
	
	##
	down_right_cell:
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 1
	
	jal is_valid_cell
	
	beq $v0, -1, reveal_exit
	
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 1
	
	jal get_cell
	
	blt $v0, 128, reveal_exit
	
	addi $a3, $v0, -128
	move $a0, $s0
	addi $a1, $s1, 1
	addi $a2, $s2, 1
	
	jal set_cell
	
	reveal_exit:
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
jr $ra

# Part VI
get_attack_target:
	
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	
	beq $a2, 'U', up_6
	beq $a2, 'D', down_6
	beq $a2, 'L', left_6
	beq $a2, 'R', right_6
	
	li $v0, -1
	j exit_6
	
	up_6:
	move $a0, $s0
	lb $a1, ($s1)
	addi $a1, $a1, -1
	lb $a2, 1($s1)
	jal get_cell
	
	j check_attackable
	
	down_6:
	move $a0, $s0
	lb $a1, ($s1)
	addi $a1, $a1, 1
	lb $a2, 1($s1)
	jal get_cell
	
	j check_attackable
	
	left_6:
	move $a0, $s0
	lb $a1, ($s1)	
	lb $a2, 1($s1)
	addi $a2, $a2, -1
	jal get_cell
	
	j check_attackable
	
	right_6:
	move $a0, $s0
	lb $a1, ($s1)
	lb $a2, 1($s1)
	addi $a2, $a2, 1
	jal get_cell
	
	
	check_attackable:
	
	bne $v0, 'm', check_if_boss
	j exit_6
	
	check_if_boss:
	bne $v0, 'B' check_if_door
	j exit_6
	
	check_if_door:
	bne $v0, '/' not_attackable
	j exit_6
	
	not_attackable:
	li $v0, -1
	
	exit_6:
	
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
jr $ra


# Part VII
complete_attack:
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $s3
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal get_cell
	
	beq $v0, 'm', attack_minion
	beq $v0, 'B', attack_boss
	beq $v0, '/', attack_door
	
	attack_minion:
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '$'
	
	jal set_cell
	
	lb $t0, 2($s1)
	addi $t0, $t0, -1
	sb $t0, 2($s1)
	j end_attack
	
	attack_boss:
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '*'
	
	jal set_cell
	
	lb $t0, 2($s1)
	addi $t0, $t0, -2
	sb $t0, 2($s1)
	j end_attack
	
	attack_door:
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '.'
	
	jal set_cell
	
	
	end_attack:
	lb $t0, 2($s1)
	bgtz $t0, alive
	
	move $a0, $s0
	lb $a1, ($s1)
	lb $a2, 1($s1)
	li $a3, 'X'
	
	jal set_cell
	
	
	alive:
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	
jr $ra


# Part VIII
monster_attacks:
	
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	
	move $s0, $a0
	move $s1, $a1
	lb $s2, ($s1) #R
	lb $s3, 1($s1) #C
	li $s4, 0  #total potential damage 
	
	move $a0, $s0
	addi $a1, $s2, -1
	addi $a2, $s3, 0
	
	jal get_cell
	
	bne $v0, 'm', if_up_is_boss
	addi $s4, $s4, 1
	
	if_up_is_boss:
	bne $v0, 'B', down_cell_8
	addi $s4, $s4, 2
	
	###
	down_cell_8:
	move $a0, $s0
	addi $a1, $s2, 1
	addi $a2, $s3, 0
	
	jal get_cell
	
	bne $v0, 'm', if_down_is_boss
	addi $s4, $s4, 1
	
	if_down_is_boss:
	bne $v0, 'B', left_cell_8
	addi $s4, $s4, 2
	
	###
	left_cell_8:
	move $a0, $s0
	addi $a1, $s2, 0
	addi $a2, $s3, -1
	
	jal get_cell
	
	bne $v0, 'm', if_left_is_boss
	addi $s4, $s4, 1
	
	if_left_is_boss:
	bne $v0, 'B', right_cell_8
	addi $s4, $s4, 2
	
	###
	right_cell_8:
	move $a0, $s0
	addi $a1, $s2, 0
	addi $a2, $s3, 1
	
	jal get_cell
	
	bne $v0, 'm', if_right_is_boss
	addi $s4, $s4, 1
	
	if_right_is_boss:
	bne $v0, 'B', exit_8
	addi $s4, $s4, 2
	
	exit_8:
	move $v0, $s4
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
jr $ra


# Part IX
player_move:
	
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	
	jal monster_attacks
	lb $t0, 2($s1)
	sub $t0, $t0, $v0
	sb $t0, 2($s1)
	
	bgtz $t0, sir_codesalot_still_ailve
	
	
	move $a0, $s0
	lb $a1, ($s1)
	lb $a2, 1($s1)
	li $a3, 'X'
	jal set_cell
	li $v0, 0
	j exit_9
	
	sir_codesalot_still_ailve:
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal get_cell
	move $s4, $v0
	
	move $a0, $s0
	lb $a1, ($s1)
	lb $a2, 1($s1)
	li $a3, '.'
	jal set_cell
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '@'
	jal set_cell
	
	sb $s2, ($s1)
	sb $s3, 1($s1)
	
	beq $s4, ',', is_floor
	beq $s4, '$', is_coin
	beq $s4, '*', is_gem
	beq $s4, '>', is_dungeon_exit
	
	is_floor:
		
	li $v0, 0
	j exit_9


	is_coin:
	
	lb $t0, 3($s1)
	addi $t0, $t0, 1
	sb $t0, 3($s1)
	li $v0, 0
	j exit_9
	
	is_gem:
	
	lb $t0, 3($s1)
	addi $t0, $t0, 5
	sb $t0, 3($s1)
	li $v0, 0
	j exit_9
	
	
	is_dungeon_exit:
	
	li $v0, -1
	
	exit_9:
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
jr $ra


# Part X
player_turn:
	
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	move $s4, $a2
	
	beq $a2,'U', X_is_U
	beq $a2,'D', X_is_D
	beq $a2,'L', X_is_L
	beq $a2,'R', X_is_R
	
	li $v0, -1
	j exit_X
	
	X_is_U:
	lb $t0, ($s1) #R
	lb $t1, 1($s1) #C
	
	addi $s2, $t0, -1
	addi $s3, $t1, 0
	j setp_2
	
	X_is_D:
	lb $t0, ($s1) #R
	lb $t1, 1($s1) #C
	
	addi $s2, $t0, 1
	addi $s3, $t1, 0
	j setp_2
	
	X_is_L:
	lb $t0, ($s1) #R
	lb $t1, 1($s1) #C
	
	addi $s2, $t0, 0
	addi $s3, $t1, -1
	j setp_2
	
	X_is_R:
	lb $t0, ($s1) #R
	lb $t1, 1($s1) #C
	
	addi $s2, $t0, 0
	addi $s3, $t1, 1
	
	
	setp_2:
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal is_valid_cell
	
	beqz $v0, step_3
	li $v0, 0
	j exit_X
	
	step_3:
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal get_cell
	
	bne $v0, '#', step_4
	li $v0, 0
	j exit_X
	
	
	step_4:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s4
	jal get_attack_target
	
	bltz $v0, not_attackable_and_move
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal complete_attack
	li $v0, 0
	j exit_X
	
	not_attackable_and_move:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal player_move
	
	exit_X:
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
	
jr $ra


# Part XI
flood_fill_reveal:
	
	
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $fp, 28($sp)
	
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal is_valid_cell
	
	bltz $v0, error_11
	
	move $fp, $sp
	
	addi $sp, $sp, -8
	sb $s1, ($sp)
	sb $s2, 4($sp)
	
	
	loop_10:
	beq $sp, $fp, success_10
	
	lb $s5, 4($sp) #col
	lb $s6, ($sp)  #row
	addi $sp, $sp, 8
	
	move $a0, $s0
	move $a1, $s6
	move $a2, $s5
	
	jal get_cell
	
	blt $v0, 128, is_already_visible
	addi $v0, $v0, -128
	
	is_already_visible:
	
	move $a0, $s0
	move $a1, $s6
	move $a2, $s5
	move $a3, $v0
	
	jal set_cell
	
	up_offset:
	move $a0, $s0
	addi $a1, $s6, -1
	addi $a2, $s5, 0
	
	jal get_cell
	
	beq $v0, '.', up_is_floor
	beq $v0, 174, up_is_floor
	j down_offset
	
		up_is_floor:
		lb $t0, 1($s0)
		addi $t1, $s6, -1
		addi $t2, $s5, 0
		
		mul $t3, $t1, $t0
		add $t3, $t3, $t2
		#addi $t3, $t3, 1
		
		li $t4, 32
		div $t3, $t4
		
		mflo $t5 #quotient
		mfhi $t6 #remainder
		
		sll $t5,$t5, 2
		
		add $t7, $s3, $t5
		lw $t8, ($t7)
		#addi $t6, $t6, -1
		li $t9, 1
		sllv $t6, $t9, $t6
		
		and $t9, $t8, $t6
		and $t0, $t9, $t6
		
		beq $t0, $t6, down_offset
		
		add $t8, $t8, $t6
		sw $t8, ($t7)
		
		addi $sp, $sp, -8
		addi $t1, $s6, -1
		addi $t2, $s5, 0
		sb $t1, ($sp)
		sb $t2, 4($sp)

	down_offset:
		
	move $a0, $s0
	addi $a1, $s6, 1
	addi $a2, $s5, 0
	
	jal get_cell
	
	beq $v0, '.', down_is_floor
	beq $v0, 174, down_is_floor
	j left_offset
	
		down_is_floor:
		lb $t0, 1($s0)
		addi $t1, $s6, 1
		addi $t2, $s5, 0
		
		mul $t3, $t1, $t0
		add $t3, $t3, $t2
		#addi $t3, $t3, 1
		
		li $t4, 32
		div $t3, $t4
		
		mflo $t5 #quotient
		mfhi $t6 #remainder
		
		sll $t5,$t5, 2
		
		add $t7, $s3, $t5
		lw $t8, ($t7)
		#addi $t6, $t6, -1
		li $t9, 1
		sllv $t6, $t9, $t6
		
		and $t9, $t8, $t6
		and $t0, $t9, $t6
		
		beq $t0, $t6, left_offset
		
		add $t8, $t8, $t6
		sw $t8, ($t7)
		
		addi $sp, $sp, -8
		addi $t1, $s6, 1
		addi $t2, $s5, 0
		sb $t1, ($sp)
		sb $t2, 4($sp)
		
		
		
		
	left_offset:
	
	move $a0, $s0
	addi $a1, $s6, 0
	addi $a2, $s5, -1
	
	jal get_cell
	
	beq $v0, '.', left_is_floor
	beq $v0, 174, left_is_floor
	j right_offset
	
		left_is_floor:
		lb $t0, 1($s0)
		addi $t1, $s6, 0
		addi $t2, $s5, -1
		
		mul $t3, $t1, $t0
		add $t3, $t3, $t2
		#addi $t3, $t3, 1
		
		li $t4, 32
		div $t3, $t4
		
		mflo $t5 #quotient
		mfhi $t6 #remainder
		
		sll $t5,$t5, 2
		
		add $t7, $s3, $t5
		lw $t8, ($t7)
		#addi $t6, $t6, -1
		li $t9, 1
		sllv $t6, $t9, $t6
		
		and $t9, $t8, $t6
		and $t0, $t9, $t6
		
		beq $t0, $t6, right_offset
		
		add $t8, $t8, $t6
		sw $t8, ($t7)
		
		addi $sp, $sp, -8
		addi $t1, $s6, 0
		addi $t2, $s5, -1
		sb $t1, ($sp)
		sb $t2, 4($sp)
	
	right_offset:
	
	move $a0, $s0
	addi $a1, $s6, 0
	addi $a2, $s5, 1
	
	jal get_cell
	
	beq $v0, '.', right_is_floor
	beq $v0, 174, right_is_floor
	j loop_10
	
		right_is_floor:
		lb $t0, 1($s0)
		addi $t1, $s6, 0
		addi $t2, $s5, 1
		
		mul $t3, $t1, $t0
		add $t3, $t3, $t2
		#addi $t3, $t3, 1
		
		li $t4, 32
		div $t3, $t4
		
		mflo $t5 #quotient
		mfhi $t6 #remainder
		
		sll $t5,$t5, 2
		
		add $t7, $s3, $t5
		lw $t8, ($t7)
		#addi $t6, $t6, -1
		li $t9, 1
		sllv $t6, $t9, $t6
		
		and $t9, $t8, $t6
		and $t0, $t9, $t6
		
		beq $t0, $t6, loop_10
		
		add $t8, $t8, $t6
		sw $t8, ($t7)
		
		addi $sp, $sp, -8
		addi $t1, $s6, 0
		addi $t2, $s5, 1
		sb $t1, ($sp)
		sb $t2, 4($sp)
	
	j loop_10
	
	error_11:
	li $v0 ,-1
	j exit_10
	
	success_10:
	li $v0, 0
	j exit_10
	
	exit_10:
	
	
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $fp, 28($sp)
	addi $sp, $sp, 32
	
	
jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
