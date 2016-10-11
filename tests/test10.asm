# Test 010
#
# Commands tested:
#   addiu, rotr, rotrv, jr, bne, beq
#
# Expected Behavior:
# If successful, it should write the 0x06 to address 4
#
main:	addiu $2, $0, 3175		# initialize $2 = 3175
		addiu $3, $0, 5			# initialize $3 = 5
		addiu $4, $0, 6			# initialize $4 = 6
		addiu $5, $0, 48		
		rotrv $6, $2, $3
		rotr $7, $2, 5
		bne $3, $4, check
		nop
		nop
		
jump:	jr $5 
		nop
		nop
		
result:	sw $4, 4($0) 		
		addi $1, $0, 1
		sw	$1, 0($0)
		
end:	beq	$0, $0, end
		nop
		
check:	beq $6, $7, jump
		nop
		
