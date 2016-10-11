# MIPS_core
MIPS core describe on Verilog with some test provided
Project was simulated using ModelSim.
For simulating just compile all files in ModelSim 10.2c and run without optimization mips_tb.v

All asm file was created by using Mars 4.5. Be careful with this program. There are some bugs in Mars 4.5. Bugs are connected 
with counting of jump address via label in beq and bne command. In addition, there are no ROTR and ROTRV command in Mars 4.5.
