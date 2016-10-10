module mips(i_clk, i_rst_n, i_external_interrupt);

  input         i_clk;
  input         i_rst_n;
  input         i_external_interrupt; //external interrupt signal
  
  wire [31:0] o_pc;
  wire [31:0] i_pc;
  wire [31:0] o_nextpc; //out of Next PC with new addr 
  wire [ 1:0] o_pcsrc; //out pc source control
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
  wire        ALUSrc_op2; //control
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
  wire		    bne; // control
  wire        nop; // for NOP command purpose
  wire        unknown_command; // unknown command in datapath signal
  wire        unknown_func; // unknown func of R-type command in datapath
  wire        arithmetic_overflow; // arithmetic overflow signal
  wire        eret;
  wire [31:0] epc_to_pc;
  wire [31:0] handler_address;
  wire        mtc0, mfc0;
  wire [31:0] cop0_data;
  wire        exception;
  
  fetch FETCH(  .i_clk(i_clk), 
                .i_rst_n(i_rst_n), 
                .i_execute(o_nextpc), 
                .i_pcsrc(o_pcsrc),
                .i_epc_to_pc(epc_to_pc), 
                .i_error_handler(handler_address), 
                .o_fetch_pc(o_pc), 
                .o_fetch_instr(o_instr)
              );
 
  decode DECODE(.i_clk(i_clk), 
                .i_rst_n(i_rst_n), 
                .i_c_regDst(regDst), 
                .i_c_regWrite(regWrite & !nop & !exception), 
                .i_Rs(o_instr[25:21]), 
                .i_Rt(o_instr[20:16]), 
                .i_Rd(o_instr[15:11]), 
                .i_wrDataToReg(o_writeToReg), 
                .i_wrAddr(o_regDest),
                .i_mfc0(mfc0), 
                .i_cop0_data(cop0_data),
                .o_decode_op1(o_bus_A), 
                .o_decode_op2(o_bus_B), 
                .o_wrAddr(o_regDest)
                );
                
  execute EXECUTE(  .i_pc(o_pc), 
                    .i_imm(o_instr[25:0]), 
                    .i_op1(o_bus_A), 
                    .i_op2(o_bus_B),
                    .i_ALUSrc_op2(ALUSrc_op2), 
                    .i_ALUop(ALUop), 
                    .i_jump(jump), 
                    .i_extOp(extOp),
                    .i_beq(beq), 
                    .i_bne(bne), 
                    .i_exception(exception),
                    .o_op2(o_op2), 
                    .o_ALUres(o_ALUResult), 
                    .o_nextPC(o_nextpc), 
                    .o_pcsrc(o_pcsrc),
                    .o_nop(nop),
                    .o_unknown_func(unknown_func),
                    .o_arithmetic_overflow(arithmetic_overflow),
                    .o_eret(eret),
                    .o_mfc0(mfc0), 
                    .o_mtc0(mtc0)
                  );
  
  memory MEMORY(  .i_clk(i_clk), 
                  .i_alu(o_ALUResult), 
                  .i_data(o_op2), 
                  .i_memWrite(memWrite & !exception), 
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
                    .o_aluSrc_op2(ALUSrc_op2), 
                    .o_regWrite(regWrite),
                    .o_extOp(extOp),
                    .o_unknown_command(unknown_command)
                  );
  cop0 COPROCESSOR0(  
                    .i_clk(i_clk), 
                    .i_rst_n(i_rst_n),
                    .i_arithmetic_overflow(arithmetic_overflow),
                    .i_unknown_command(unknown_command),
                    .i_unknown_func(unknown_func),
                    .i_external_interrupt(i_external_interrupt),
                    .i_data(o_bus_B),
                    .i_address(o_instr[15:11]),
                    .i_pc_to_epc(o_pc),
                    .i_mtc0(mtc0),
                    .i_eret(eret),
                    .o_epc_to_pc(epc_to_pc),
                    .o_exeption(exception),
                    .o_handler_address(handler_address),
                    .o_data(cop0_data)
                  );

endmodule