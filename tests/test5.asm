# Test 005
#
# Tests shift operations.
#
# Commands tested:
#   addiu, srl, srlv, sll, sllv, sra, srav, xor, ori, beq, j, nop
#
# Expected Behavior:
# If successful, it should write the value 0x0ffffffc to address 4
#			
main:   addiu $2, $0, 0x7f      # $2 = 0x7f
        srl   $3, $2, 5         # $3 = 0x7f >> 5 = 0x03
        sllv  $2, $2, $3        # $2 = 0x7f << 3 = 0x3f8
        sll   $4, $2, 22        # $4 = 0x3f8 << 22 = 0xfe000000
        sra   $4, $4, 22        # $4 = 0xffc00000 >>> 22 = 0xfffffff8
        lui   $5, 0x8000        # $5 = 0x8000000
        xor   $4, $4, $5        # $4 = 0xffffffff ^ 0x80000000 = 0x7ffffff8
        ori   $5, $0, 5         # $5 = 5
        srav  $4, $4, $5        # $4 = 0x7ffffff8 >> 5 = 0x03ffffff
        sllv  $4, $4, $3        # $4 = 0x03ffffff << 3 = 0x1ffffff8
        srl   $3, $3, 1         # $3 = 0x03 >> 1 = 0x01
        srlv  $4, $4, $3        # $4 = 0x1ffffff8 >> 1 = 0x0ffffffc
        sw    $4, 4($0)         # should write 0x0ffffffc to address 4 (result for tb)
				addi  $1, $0, 1					# initialize $1 = 1
				sw	  $1, 0($0)					# should write 1 to address 0 (finish for tb)
