module decode (i_clk, i_rst_n, i_c_regDst, i_c_regWrite, 
               i_Rs, i_Rt, i_Rd, i_wrDataToReg, i_wrAddr,
               i_pc, i_imm, i_jump, i_bne, i_beq,
               i_ALUres, i_mem, i_mux_ctrl1, i_mux_ctrl2,
               o_nextPC, o_pcsrc,
               o_decode_op1, o_decode_op2,o_wrAddr);
  
  input wire         i_clk, i_rst_n;
  input wire         i_c_regDst, i_c_regWrite; //control signal
  
  input wire  [4:0]  i_Rs;
  input wire  [4:0]  i_Rt; 
  input wire  [4:0]  i_Rd; //addr of reg in regFile
  
  input wire  [31:0] i_wrDataToReg; //data that need to be wrote into regFile
  input wire  [4:0]  i_wrAddr; //input of write address
  
  input wire  [31:0] i_pc;
  input wire  [25:0] i_imm;
  input wire         i_jump, i_beq, i_bne;
  
  input wire  [31:0] i_ALUres;
  input wire  [31:0] i_mem;
  input wire  [ 1:0] i_mux_ctrl1, i_mux_ctrl2;
  
  output wire [31:0] o_decode_op1; 
  output wire [31:0] o_decode_op2; 
  
  output wire [4:0]  o_wrAddr; //output of write address (need for corect pipelining)
  
  output wire [31:0] o_nextPC;
  output wire        o_pcsrc;
  
  wire        [31:0] busA, busB;
  
  localparam WIDTH = 5;
  
  mux2in1 #(.WIDTH(WIDTH)) REGDEST(i_Rt, i_Rd, i_c_regDst, o_wrAddr);  
  regFile REGISTERS(i_clk, i_rst_n,
                    i_Rs, i_Rt, i_wrAddr,
                    i_wrDataToReg, i_c_regWrite, busA,
                    busB);
  mux4in1 MUX_OP_1(busA, i_ALUres, i_mem, i_wrDataToReg, i_mux_ctrl1, o_decode_op1);
  mux4in1 MUX_OP_2(busB, i_ALUres, i_mem, i_wrDataToReg, i_mux_ctrl2, o_decode_op2);
  
  nextPC NEXTPC(i_pc, i_imm, i_jump, i_beq, i_bne, 
                o_decode_op1,o_decode_op2, o_nextPC, o_pcsrc);
                  
  
endmodule
