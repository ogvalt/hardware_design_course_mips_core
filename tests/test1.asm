# Test 001
#
# Commands tested:
#   addi, add, beq, sw, nop, j
#
# Expected Behavior:
# If successful, it should write the value 0x15 to address 4
#	
main:   addi $2, $0, 0          # initialize $2 = 0
        addi $3, $0, 1          # initialize $3 = 1
        addi $5, $0, 21         # initialize $5 = 21 (stopping point)
loop:   add  $4, $2, $3         # $4 <= $2 + $3
        add  $2, $3, $0         # $2 <= $3
        add  $3, $4, $0         # $3 <= $4
        beq  $4, $5, result     # when sum is 21, jump to write
        nop
        beq  $0, $0, loop       # loop (beq is easier to assemble than jump)
        nop
result: sw   $4, 4($0)          # should write 21 to address 4 (result for tb)
  			addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
end:    beq  $0, $0, end        # loop forever
        nop

except: # if exception occurs, then finish test
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
				eret
