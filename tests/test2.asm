# Test 002
#
# Commands tested:
#   add, sub, andi, or, slt, addi, lw, sw, beq, j, nop
#
# Expected Behavior:
# If successful, it should write the value 7 to address 4
#
main:   addi $2, $0, 5          # initialize $2 = 5
        addi $3, $0, 12         # initialize $3 = 12
        addi $7, $3, -9         # initialize $7 = 3
        or   $4, $7, $2         # $4 <= 3 or 5 = 7
        and  $5, $3, $4         # $5 <= 12 and 7 = 4
        add  $5, $5, $4         # $5 = 4 + 7 = 11
        beq  $5, $7, end        # shouldn't be taken
        nop                     # Avoid branch delay slot
        slt  $4, $3, $4         # $4 = 12 < 7 = 0
        beq  $4, $0, around     # should be taken
        nop                     # Avoid branch slot
        addi $5, $0, 0          # shouldn't happen
around: slt  $4, $7, $2         # $4 = 3 < 5 = 1
        add  $7, $4, $5         # $7 = 1 + 11 = 12
        sub  $7, $7, $2         # $7 = 12 - 5 = 7
        sw   $7, 8($3)          # [20] = 7
        lw   $2, 20($0)         # $2 = [20] = 7
        j    end                # should be taken
        nop                     # Avoid branch slot
        addi $2, $0, 1          # shouldn't happen
end:    sw   $2, 4($0)          # write adr 4 = 7 (result for tb)
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
loop:   beq  $0, $0, loop       # loop forever
        nop                     # Avoid branch slot

except: # if exception occurs, then finish test
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
				eret
