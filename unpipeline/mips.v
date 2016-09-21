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
  wire [5:0]  ALUop; // opcode from control to ALUctrl
  wire        jump; //control
  wire        beq; //control
  wire		      bne; // control
  
  fetch FETCH(  .i_clk(i_clk), 
                .i_rst_n(i_rst_n), 
                .i_execute(o_nextpc), 
                .i_pcsrc(o_pcsrc), 
                .o_fetch_pc(o_pc), 
                .o_fetch_instr(o_instr)
              );
 
  decode DECODE(.i_clk(i_clk), 
                .i_rst_n(i_rst_n), 
                .i_c_regDst(regDst), 
                .i_c_regWrite(regWrite), 
                .i_Rs(o_instr[25:21]), 
                .i_Rt(o_instr[20:16]), 
                .i_Rd(o_instr[15:11]), 
                .i_wrDataToReg(o_writeToReg), 
                .i_wrAddr(o_regDest),
                .o_decode_op1(o_bus_A), 
                .o_decode_op2(o_bus_B), 
                .o_wrAddr(o_regDest)
                );
                
  execute EXECUTE(  .i_pc(o_pc), 
                    .i_imm(o_instr[25:0]), 
                    .i_op1(o_bus_A), 
                    .i_op2(o_bus_B),
                    .i_ALUSrc(ALUSrc), 
                    .i_ALUop(ALUop), 
                    .i_jump(jump), 
                    .i_extOp(extOp),
                    .i_beq(beq), 
                    .i_bne(bne), 
                    .o_op2(o_op2), 
                    .o_ALUres(o_ALUResult), 
                    .o_nextPC(o_nextpc), 
                    .o_pcsrc(o_pcsrc)
                  );
  
  memory MEMORY(  .i_clk(i_clk), 
                  .i_alu(o_ALUResult), 
                  .i_data(o_op2), 
                  .i_memWrite(memWrite), 
                  .i_memToReg(memToReg), 
                  .o_data(o_writeToReg)
                );
  
  control CONTROL(  .i_instrCode(o_instr[31:26]), 
                    .o_regDst(regDst), 
                    .o_jump(jump), 
                    .o_beq(beq), 
                    .o_bne(bne), 
                    .o_memToReg(memToReg), 
                    .o_aluOp(ALUop), 
                    .o_memWrite(memWrite), 
                    .o_aluSrc(ALUSrc), 
                    .o_regWrite(regWrite),
                    .o_extOp(extOp)
                  );
  
  initial begin //clock set up
    i_clk <= 1'b0;
    #1;
    forever #1 i_clk <= ~i_clk;
  end
  initial begin //initial reset
    i_rst_n <= 1'b0;
    #1;
    i_rst_n <= 1'b1;
  end 
  initial $readmemh("G:/STUDING/melexis/lab5/unpipeline/rom_init.dat", FETCH.ROM.memory); 
endmodule