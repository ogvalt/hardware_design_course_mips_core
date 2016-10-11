# Test 003
#
# Tests immediate instructions, hazards, negative numbers. 
#
# Commands tested:
#   addiu, addu, lui, ori, xori, sw, beq, j, nop
#
# Expected Behavior:
# If successful, it should write the value 14 to address 4
#	
main:   addiu $2, $0, -10       # $2 = -10
        addiu $3, $0, 10        # $3 = 10
        addu  $2, $2, $3        # $2 = $2 + $3 = -10 + 10 = 0
        addiu $4, $2, 100       # $4 = $2 + 100 = 0 + 10 = 100
        addiu $5, $2, -100      # $5 = $2 + -100 = -100
        addu  $2, $2, $3        # $2 = $2 + $3 = 0 + 0 = 0
        lui   $4, 0x70f0        # $4 = 0x70f00000
        ori   $4, $4, 0xf000    # $4 = 0x70f00000 | 0x0000f000 = 0x70f0f000
        xori  $4, $4, 0xfff0    # $4 = 0x70f0f000 ^ 0x0000fff0 = 0x70f00ff0
        # although sltiu is unsigned, normal sign extension still occurs on the
        # immediate value
        addu  $2, $2, $3        # $2 = $2 + $3 = 1 + 1 = 2
write:  sw   $2, 4($0)          # should write 2 to address 4 (result for tb)
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
