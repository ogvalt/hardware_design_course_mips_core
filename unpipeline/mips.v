module mips();
  reg         i_clk;
  reg         i_rst_n;
  
  wire [31:0] o_pc;
  wire [31:0] i_pc;
  wire [31:0] o_nextpc; //out of Next PC with new addr 
  wire        o_pcsrc; //out pc source control
  wire [31:0] o_instr;
  wire [31:0] o_writeToReg; // register file write data
  wire        regWrite; //control
  wire        regDst; //control
  wire [4:0]  o_regDest; //input for register write addr
  wire        extOp; // control
  wire [31:0] o_extend; //extender output
  wire [31:0] o_bus_A; // regFile read bus A output;
  wire [31:0] o_bus_B; // regFile read bus B output;
  wire [31:0] o_op2;
  wire        ALUSrc; //control
  wire [31:0] o_alusource; //input second operand of ALU
  wire [3:0]  ALUCtrl; //ALUcontrol
  wire [31:0] o_ALUResult; //ALU output, input for memory or register
  wire        o_zero; // zero flag, use for beqe if equal (BEQ)
  wire        memWrite; //control
  wire [31:0] o_dataMemory; //output of data memory
  wire        memToReg; // control
  wire [1:0]  ALUop; // opcode from control to ALUctrl
  wire        jump; //control
  wire        beq; //control
  wire		      bne; // control
  
  fetch FETCH(i_clk, i_rst_n, o_nextpc, o_pcsrc, o_pc, o_instr);
 
  decode DECODE(i_clk, i_rst_n, regDst, regWrite, 
                o_instr[25:21], o_instr[20:16], 
                o_instr[15:11], o_writeToReg, o_regDest,
                o_bus_A, o_bus_B, o_regDest);
                
  execute EXECUTE(o_pc, o_instr[25:0], o_bus_A, o_bus_B,
                  ALUSrc, ALUop, jump, extOp,
                  beq, bne, o_op2, 
                  o_ALUResult, o_nextpc, o_pcsrc);
  
  memory MEMORY(i_clk, o_ALUResult, o_op2, memWrite, memToReg, o_writeToReg);
  
  control CONTROL(o_instr[31:26], regDst, jump, beq, bne, 
                  memToReg, ALUop, memWrite, ALUSrc, regWrite, extOp);
  
  initial begin //clock set up
    #1;
    i_clk <= 1'b0;
    forever #1 i_clk <= ~i_clk;
  end
  initial begin //initial reset
    i_rst_n <= 1'b0;
    #1;
    i_rst_n <= 1'b1;
  end 
  initial $readmemh("G:/STUDING/melexis/lab5/unpipeline/rom_init.dat", FETCH.ROM.memory); 
endmodule