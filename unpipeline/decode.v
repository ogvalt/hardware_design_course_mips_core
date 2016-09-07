module decode (i_clk, i_rst_n, i_c_regDst, i_c_regWrite, 
               i_Rs, i_Rt, i_Rd, i_wrDataToReg, i_wrAddr,
               o_decode_op1, o_decode_op2,o_wrAddr);
  
  input wire         i_clk, i_rst_n;
  input wire         i_c_regDst, i_c_regWrite; //control signal
  
  input wire  [4:0]  i_Rs;
  input wire  [4:0]  i_Rt; 
  input wire  [4:0]  i_Rd; //addr of reg in regFile
  
  input wire  [31:0] i_wrDataToReg; //data that need to be wrote into regFile
  input wire  [4:0]  i_wrAddr; //input of write address
  
  output wire [31:0] o_decode_op1; 
  output wire [31:0] o_decode_op2; //operandrs
  
  output wire [4:0]  o_wrAddr; //output of write address (need for corect pipelining)
    
  regFile REGISTERS(i_clk, i_rst_n,
                    i_Rs, i_Rt, o_wrAddr,
                    i_wrDataToReg, i_c_regWrite, o_decode_op1,
                    o_decode_op2);
  mux2in1 REGDEST(i_Rt, i_Rd, i_c_regDst, o_wrAddr);
  
endmodule
