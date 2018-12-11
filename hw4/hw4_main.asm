.data
map_filename: .asciiz "map4.txt"
# num words for map: 45 = (num_rows * num_cols + 2) // 4 
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212
0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 
0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212  
.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD
.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"

.text
print_map:
la $t0, map  # the function does not need to take arguments

	lb $a0, ($t0)
	li $v0, 1
	syscall
	move $t1, $a0 #num of rows
	
	li $a0,' '
	li $v0, 11
	syscall
	
	lb $a0, 1($t0)
	li $v0, 1
	syscall
	move $t2, $a0 #num of cols
	
	li $a0,'\n'
	li $v0, 11
	syscall
	
	addi $t0, $t0, 2

	mul $t4, $t1, $t2
	
	li $t5, 0
	li $t6, 0
	print_map_loop:
	beq $t6, $t4, end_print_map
	bne $t5, $t2, not_new_line
	
	li $a0,'\n'
	li $v0, 11
	syscall
	li $t5, 0
	
	not_new_line:
	lbu $a0, ($t0)
	blt $a0, 128, print_it
	li $a0, ' '
	########
	#addi $a0, $a0, -128
	print_it:
	li $v0, 11
	syscall
	
	
	addi $t0, $t0, 1
	addi $t5, $t5, 1
	addi $t6, $t6, 1
	
	j print_map_loop
	
	end_print_map:
	li $a0,'\n'
	li $v0, 11
	syscall
	li $t5, 0

jr $ra

print_player_info:
# the idea: print something like "Pos=[3,14] Health=[4] Coins=[1]"
la $t0, player
		
	la $a0, pos_str
	li $v0, 4
	syscall
	
	lb $a0, ($t0)
	li $v0, 1
	syscall
	
	li $a0, ','
	li $v0, 11
	syscall
	
	lb $a0, 1($t0)
	li $v0, 1
	syscall
	
	la $a0, health_str
	li $v0, 4
	syscall
	
	lb $a0, 2($t0)
	li $v0, 1
	syscall
	
	la $a0, coins_str
	li $v0, 4
	syscall
	
	lb $a0, 3($t0)
	li $v0, 1
	syscall
	
	li $a0, ']'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
jr $ra


.globl main
main:
la $a0, welcome_msg
li $v0, 4
syscall

# fill in arguments

	la $a0, map_filename
	la $a1, map
	la $a2, player
	

jal init_game



# fill in arguments

	la $a0, map
	la $t0, player
	lb $a1, ($t0)
	lb $a2, 1($t0)

jal reveal_area

li $s0, 0  # move = 0

game_loop:  # while player is not dead and move == 0:

jal print_map # takes no args

jal print_player_info # takes no args


#############

	

	
#############



# print prompt
la $a0, your_move_str
li $v0, 4
syscall

li $v0, 12  # read character from keyboard
syscall
move $s1, $v0  # $s1 has character entered
li $s0, 0  # move = 0

li $a0, '\n'
li $v0 11
syscall

# handle input: w, a, s or d
	beq $s1, 'w', move_up
	beq $s1, 'a', move_left
	beq $s1, 'd', move_right
	beq $s1, 's', move_down
	beq $s1, 'r', flood_fill
	
	move_up:
	li $a2, 'U'
	j player_turn_main
	
	move_left:
	li $a2, 'L'
	j player_turn_main
	
	move_right:
	li $a2, 'R'
	j player_turn_main
	
	move_down:
	li $a2, 'D'
	j player_turn_main
	
	flood_fill:
	###
	la $a0, map
	la $a3, player
	lb $a1, ($a3)
	lb $a2, 1($a3)
	la $a3, visited
	jal flood_fill_reveal
	
	j whatever_loop
# map w, a, s, d  to  U, L, D, R and call player_turn()

	player_turn_main:
	la $a0, map
	la $a1, player
	jal player_turn
	
	
# if move == 0, call reveal_area()  Otherwise, exit the loop.

	whatever_loop:
	
	bnez $v0, game_over
	la $a0, map
	la $t0, player
	lb $a1, ($t0)
	lb $a2, 1($t0)
	jal reveal_area
	
	
j game_loop

game_over:
jal print_map
jal print_player_info
li $a0, '\n'
li $v0, 11
syscall

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won

won:
la $a0, you_won_str
li $v0, 4
syscall
j exit

failed:
la $a0, you_failed_str
li $v0, 4
syscall
j exit

player_dead:
la $a0, you_died_str
li $v0, 4
syscall

exit:
li $v0, 10
syscall

.include "hw4.asm"
