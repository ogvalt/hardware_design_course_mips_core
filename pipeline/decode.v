module decode (i_clk, i_rst_n, i_c_regDst, i_c_regWrite, 
               i_Rs, i_Rt, i_Rd, i_wrDataToReg, i_wrAddr,
               i_pc, i_imm, i_jump, i_bne, i_beq,
               i_ALUres, i_mem, i_mux_ctrl1, i_mux_ctrl2,
               i_ALUop, i_exception, 
               o_aluCtrl, o_ALUSrc_op1,
               o_nextPC, o_pcsrc,
               o_decode_op1, o_decode_op2,o_wrAddr,
               o_nop, o_unknown_func, o_eret
              );
  
  input              i_clk, i_rst_n;
  input              i_c_regDst, i_c_regWrite; //control signal
  
  input       [4:0]  i_Rs;
  input       [4:0]  i_Rt; 
  input       [4:0]  i_Rd; //addr of reg in regFile
  
  input       [31:0] i_wrDataToReg; //data that need to be wrote into regFile
  input       [4:0]  i_wrAddr; //input of write address
  
  input       [31:0] i_pc;
  input       [25:0] i_imm;
  input              i_jump, i_beq, i_bne;
  
  input       [31:0] i_ALUres;
  input       [31:0] i_mem;
  input       [ 1:0] i_mux_ctrl1, i_mux_ctrl2;

  input       [ 5:0] i_ALUop;
  input              i_exception;
  
  output      [31:0] o_decode_op1; 
  output      [31:0] o_decode_op2; 
  
  output      [4:0]  o_wrAddr; //output of write address (need for corect pipelining)
  
  output      [31:0] o_nextPC;
  output             o_pcsrc;
  output      [ 5:0] o_aluCtrl;
  output             o_ALUSrc_op1;
  output             o_nop;
  output             o_unknown_func;
  output             o_eret;
  
  wire        [31:0] busA, busB;
  wire               jr, eret;
  
  localparam WIDTH = 5;
  
  mux2in1 #(.WIDTH(WIDTH)) REGDEST ( .i_dat0(i_Rt), 
                                     .i_dat1(i_Rd), 
                                     .i_control(i_c_regDst), 
                                     .o_dat(o_wrAddr)
                                    );  

  regFile REGISTERS( .i_clk(i_clk), 
                     .i_rst_n(i_rst_n),
                     .i_raddr1(i_Rs), 
                     .i_raddr2(i_Rt), 
                     .i_waddr(i_wrAddr),
                     .i_wdata(i_wrDataToReg), 
                     .i_we(i_c_regWrite), 
                     .o_rdata1(busA),
                     .o_rdata2(busB)
                    );

  mux4in1 MUX_OP_1 (  .i_op1(busA), 
                      .i_op2(i_ALUres), 
                      .i_op3(i_mem), 
                      .i_op4(i_wrDataToReg), 
                      .i_ctrl(i_mux_ctrl1), 
                      .o_res(o_decode_op1)
                    );

  mux4in1 MUX_OP_2( .i_op1(busB), 
                    .i_op2(i_ALUres), 
                    .i_op3(i_mem), 
                    .i_op4(i_wrDataToReg), 
                    .i_ctrl(i_mux_ctrl2), 
                    .o_res(o_decode_op2)
                  );
  
  nextPC NEXTPC ( .i_pc(i_pc), 
                  .i_imm(i_imm), 
                  .i_jump(i_jump), 
                  .i_beq(i_beq), 
                  .i_bne(i_bne),
                  .i_jr(jr),
                  .i_busA(o_decode_op1), 
                  .i_busB(o_decode_op2),
                  .i_exception(i_exception),
                  .o_nextpc(o_nextPC), 
                  .o_pcsrc(o_pcsrc)
                );

  aluControl ALUCONTROL(.i_aluOp(i_ALUop), 
                        .i_func(i_imm[5:0]), 
                        .i_r_field(i_imm[10:6]|i_imm[25:21]),
                        .o_aluControl(o_aluCtrl),
                        .o_ALUSrc_op1(o_ALUSrc_op1),
                        .o_jr(jr),
                        .o_nop(o_nop),
                        .o_unknown_func(o_unknown_func),
                        .o_eret(eret),
                        .o_mfc0(), 
                        .o_mtc0()
                        );

  assign o_eret = eret;                
  
endmodule
